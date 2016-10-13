<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	LoginUserDto userDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    position: fixed;
    top: 5%;
    left: 30%;
    
    margin-left: -300px;
    width: 825px;
    
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

<!-------------------------------- Dialog Div Start -------------------------------->
<script type="text/javascript">
$(function(){
    $("#proposalDetailPop").draggable();
	$("#regiJqmButton").hide();
	$("#modiJqmButton").hide();
	$("#reviewJqmButton").hide();
	$("#finalJqmButton").hide();
	$("#delJqmButton").hide();
	$("#receJqmButton").hide();
	$(".FileTdInDiv1").hide();
	$(".FileTdInDiv2").hide();
	$(".FINAL_RESULT_PRINT").hide();

	$('#proposalDetailPop').jqm();  //Dialog 초기화

	$("#regiUserEmail").css("ime-mode","disabled");
	$("#regiUserPhone").css("ime-mode","disabled");

	$("#regiJqmButton").click(function(){
		regiProposalInfo();
	});
	$("#modiJqmButton").click(function(){
		modiProposalInfo();
	});
	$("#reviewJqmButton").click(function(){
		revieProcess();
	});
	$("#finalJqmButton").click(function(){
		finalProcess();
	});
	$("#delJqmButton").click(function(){ 
		delProposalInfo();
	});
	$("#receJqmButton").click(function(){ 
		receProposalInfo();
	});
	$("#closeButton").click(function(){ //Dialog 닫기
		clearInputInfo();
		$('#proposalDetailPop').jqmHide();
	});
	$("#propPrintBtn").click(function(){
		openReceiptPrint();
	});
});

var fnProposalCallback = "";
function fnProposalDetailDiv(callbackString,flag,selRowContent) {
   $("#proposalDetailPop").jqmShow();
   fnProposalCallback =  callbackString;
   $("#duplChk").val("0");
   if(flag == "R"){
	   $("#detailPrintTabel").attr("display","none");
	   $(".SKTS_RESULT").hide();
	   $(".FINAL_RESULT").hide();
	   $("#regiJqmButton").show();
	   $("#modiJqmButton").hide();
	   $("#reviewJqmButton").hide();
	   $("#finalJqmButton").hide();
	   $("#delJqmButton").hide();
	   $("#receJqmButton").hide();
	   $(".FileTdInDiv1").show();
	   $(".FileTdInDiv2").hide();
	   $("#stepTitle1").text("접수대기");
	   $("#stepTitle2").text("검토중");
	   $("#stepTitle3").text("적합여부");
	   $("#stepTitle4").text("채택여부");
	   $("#stepStatus1").html("<img src='/img/system/process_arrow_02.gif' border='0'/>");
	   $("#stepStatus2").html("");
	   $("#stepStatus3").html("");
	   $("#stepStatus4").html("");

	   $(".FINAL_RESULT_PRINT").hide();  
	   $.post
	   ( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/selectProposalUserInfo.sys',
            {},
            function(arg){
                var userInfo = eval('(' + arg + ')').userInfo;
                var proposalDate = eval('(' + arg + ')').proposalDate;
				$("#propStatus").val("접수대기");
				$("#propStatus").css("border","0px");
				$("#propStatus").attr("readonly",true);
				$("#regiDateTime").css("border","0px");
				$("#regiDateTime").attr("readonly",true);
				$("#regiUserName").val(userInfo.gradeNm);
				$("#regiUserPhone").val(userInfo.mobile);
				$("#regiUserEmail").val(userInfo.email);
				$("#regiDateTime").val(proposalDate);
// 수정 변경 요청 14-03-27 parkjoon
// 				if(userInfo.userId != ''){
// 					$("#regiUserName").css("border","0px");
// 					$("#regiUserName").attr("readonly",true);
// 				}
            }
	   );
   }else if(flag == "D"){
	   $("#receiptNum").val(selRowContent.RECEIPTNUM);
	   $("#receiptNumStat").val(selRowContent.FINALPROCSTATFLAG);
	   $("#titleName").val(selRowContent.SUGGESTTITLE);
	   $("#propStatus").val(selRowContent.FINALPROCSTATFLAG_NM);
	   $("#regiUserName").val(selRowContent.SUGGESTNAME);
	   $("#regiDateTime").val(selRowContent.SUGGESTDATE);
	   $("#regiUserPhone").val(selRowContent.SUGGESTPHONE);
	   $("#regiUserEmail").val(selRowContent.SUGGESTEMAIL);
	   $("#propPointDesc").val(selRowContent.SUGGESTCONTENT);
	   $("#firstattachseq").val(selRowContent.FILELIST1);
	   $("#secondattachseq").val(selRowContent.FILELIST2);
	   $("#thirdattachseq").val(selRowContent.FILELIST3);
	   $("#suitableStat").val(selRowContent.SUITABLESTAT);
	   $("#suitableContent").val(selRowContent.SUITABLECONTENT);
	   $("#materialType").val(selRowContent.MATERIALTYPE);
	   $("#fourthattachseq").val(selRowContent.MATERIALTYPE);
	   $("#appraisalStat").val(selRowContent.APPRAISALSTAT);
	   $("#appraisalContent").val(selRowContent.APPRAISALCONTENT);
	   $("#firstattachseq").val(selRowContent.FILELIST1);
	   $("#attach_file_name1").text(selRowContent.ATTACH_FILE_NAME1);
	   $("#attach_file_path1").val(selRowContent.ATTACH_FILE_PATH1);
	   $("#secondattachseq").val(selRowContent.FILELIST2);
	   $("#attach_file_name2").text(selRowContent.ATTACH_FILE_NAME2);
	   $("#attach_file_path2").val(selRowContent.ATTACH_FILE_PATH2);
	   $("#thirdattachseq").val(selRowContent.FILELIST3);
	   $("#attach_file_name3").text(selRowContent.ATTACH_FILE_NAME3);
	   $("#attach_file_path3").val(selRowContent.ATTACH_FILE_PATH3);
	   $("#fourthattachseq").val(selRowContent.FILELIST4);
	   $("#attach_file_name4").text(selRowContent.ATTACH_FILE_NAME4);
	   $("#attach_file_path4").val(selRowContent.ATTACH_FILE_PATH4);
	   $("#regiDateTime").css("border","0px");
	   $("#regiDateTime").attr("readonly",true);
	   $("#propStatus").css("border","0px");
	   $("#propStatus").attr("readonly",true);
	   $("#regiUserName").css("border","0px");
	   $("#regiUserName").attr("readonly",true);
	   if((selRowContent.SUGGESTTARGETVAL == null || selRowContent.SUGGESTTARGETVAL == "") && 
		   (selRowContent.SUITABLE_USER_NM == null || selRowContent.SUITABLE_USER_NM == "") && 
		   (selRowContent.SUITABLE_MOBILE == null || selRowContent.SUITABLE_MOBILE == "")){
		   $("#suggestTarget").attr("disabled",false);
		   $("#suggestTargetName").html("<%=userDto.getUserNm()%>");
		   $("#suitableMobile").html("<%=userDto.getMobile()%>");
	   }else{
		   $("#suggestTarget").attr("disabled",true);
		   $("#suggestTarget").val(selRowContent.SUGGESTTARGETVAL);
		   $("#suggestTargetName").html(selRowContent.SUITABLE_USER_NM);
		   $("#suitableMobile").html(selRowContent.SUITABLE_MOBILE);
	   }
	   $("#stepTitle1").text("접수대기");
	   $("#stepTitle2").text("검토중");
	   $("#stepTitle3").text("적합여부");
	   $("#stepTitle4").text("채택여부");
	   $("#stepStatus1").html("");
	   $("#stepStatus2").html("");
	   $("#stepStatus3").html("");
	   $("#stepStatus4").html("");

	   $(".FINAL_RESULT_PRINT").hide();  
	   $.post
	   ( 
            '<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/selectProposalDetailRole.sys',
            {
	   			receiptNum:$("#receiptNum").val()
            },
            function(arg){
                var userRoleObj = eval('(' + arg + ')').userInfo;
                var final_role = userRoleObj.FINAL_ROLE;
                var is_writer = userRoleObj.IS_WRITER;
                var is_adm = userRoleObj.IS_ADM;
			    if(selRowContent.FINALPROCSTATFLAG <= "10"){
	   			   $("#stepStatus1").html("<img src='/img/system/process_arrow_02.gif' border='0'/>");
				   $("#regiJqmButton").hide();
				   if(is_writer == "Y"){
				   	  $("#modiJqmButton").show();
				   }else{
				   	  $("#modiJqmButton").hide();
				   }
				   $("#reviewJqmButton").hide();
				   $("#finalJqmButton").hide();
				   if(is_writer == "Y" || is_adm == "Y"){
				      $("#delJqmButton").show();
				   }else{
				      $("#delJqmButton").hide();
				   }
				   if(is_adm == "Y"){
				      $("#receJqmButton").show();
				   }else{
				      $("#receJqmButton").hide();
				   }
				   $(".FileTdInDiv1").show();
				   $(".FileTdInDiv2").hide();

				   $("#detailPrintTabel").attr("display","none");
				   $(".SKTS_RESULT").hide();
				   $(".FINAL_RESULT").hide();

				   // 수정 변경 요청 14-03-27 parkjoon
				   $("#regiUserName").css("border","1px solid #aeaeae"); 
				   $("#regiUserName").attr("readonly",false);
	   			}else if(selRowContent.FINALPROCSTATFLAG <= "20"){
	   			   $("#stepStatus2").html("<img src='/img/system/process_arrow_02.gif' border='0'/>");
				   $("#regiJqmButton").hide();
				   $("#modiJqmButton").hide();
				   if(is_adm == "Y"){
				      $("#reviewJqmButton").show();
				      $(".SKTS_RESULT").show();
				   }else{
				      $("#reviewJqmButton").hide();
				      $(".SKTS_RESULT").hide();
				   }
				   $("#finalJqmButton").hide();
				   $("#delJqmButton").hide();
				   $("#receJqmButton").hide();
				   $(".FileTdInDiv1").hide();
				   $(".FileTdInDiv2").show();

				   $("#detailPrintTabel").attr("display","none");
				   $(".FINAL_RESULT").hide();
				   $("#titleName").css("border","0px");
				   $("#titleName").attr("readonly",true);
				   $("#regiUserName").css("border","0px");
				   $("#regiUserName").attr("readonly",true);
				   $("#regiUserPhone").css("border","0px");
				   $("#regiUserPhone").attr("readonly",true);
				   $("#regiUserEmail").css("border","0px");
				   $("#regiUserEmail").attr("readonly",true);
				   $("#propPointDesc").css("border","0px");
				   $("#propPointDesc").attr("readonly",true);
		
				   $("#suitableStat").attr("disabled",false); 
				   $("#suitableContent").css("border","1px solid #aeaeae"); 
				   $("#suitableContent").attr("readonly",false);
				   $("#materialType").css("border","1px solid #aeaeae"); 
				   $("#materialType").attr("readonly",false);
	   			}else if(selRowContent.FINALPROCSTATFLAG <= "32"){
	   			   $("#stepTitle3").text($("#propStatus").val());
	   			   $("#stepStatus3").html("<img src='/img/system/process_arrow_02.gif' border='0'/>");
				   $("#regiJqmButton").hide();
				   $("#modiJqmButton").hide();
				   $("#reviewJqmButton").hide();
				   alert(final_role);
				   if(final_role == "Y"){
				      $("#finalJqmButton").show();
				      $(".FINAL_RESULT").show();
				   }else{
				      $("#finalJqmButton").hide();
				      $(".FINAL_RESULT").hide();
				   }
				   $("#delJqmButton").hide();
				   $("#receJqmButton").hide();
				   $(".FileTdInDiv1").hide();
				   $(".FileTdInDiv2").hide();  

				   $("#detailPrintTabel").attr("display","none");
				   $(".SKTS_RESULT").show();
				   $("#titleName").css("border","0px");
				   $("#titleName").attr("readonly",true);
				   $("#regiUserName").css("border","0px");
				   $("#regiUserName").attr("readonly",true);
				   $("#regiUserPhone").css("border","0px");
				   $("#regiUserPhone").attr("readonly",true);
				   $("#regiUserEmail").css("border","0px");
				   $("#regiUserEmail").attr("readonly",true);
				   $("#propPointDesc").css("border","0px");
				   $("#propPointDesc").attr("readonly",true);
		
				   $("#suitableStat").attr("disabled",true); 
				   $("#suitableContent").css("border","0px"); 
				   $("#suitableContent").attr("readonly",true);
				   $("#materialType").css("border","0px"); 
				   $("#materialType").attr("readonly",true);
		
				   $("#appraisalStat").attr("disabled",false); 
		           $("#appraisalContent").css("border","1px solid #aeaeae"); 
		           $("#appraisalContent").attr("readonly",false);
	   			}else if(selRowContent.FINALPROCSTATFLAG <= "42"){
	   			   $("#stepTitle3").text(selRowContent.SUITABLESTAT_NM);
	   			   $("#stepTitle4").text($("#propStatus").val());
	   			   $("#stepStatus4").html("<img src='/img/system/process_arrow_02.gif' border='0'/>");
				   $("#regiJqmButton").hide();
				   $("#modiJqmButton").hide();
				   $("#reviewJqmButton").hide();
				   $("#finalJqmButton").hide();
				   $("#delJqmButton").hide();
				   $("#receJqmButton").hide();
				   $(".FileTdInDiv1").hide();
				   $(".FileTdInDiv2").hide();

				   $("#detailPrintTabel").attr("display","block");
				   $(".SKTS_RESULT").show();
				   $(".FINAL_RESULT").show();
				   $(".FINAL_RESULT_PRINT").show();
				   $("#titleName").css("border","0px");
				   $("#titleName").attr("readonly",true);
				   $("#regiUserName").css("border","0px");
				   $("#regiUserName").attr("readonly",true);
				   $("#regiUserPhone").css("border","0px");
				   $("#regiUserPhone").attr("readonly",true);
				   $("#regiUserEmail").css("border","0px");
				   $("#regiUserEmail").attr("readonly",true);
				   $("#propPointDesc").css("border","0px");
				   $("#propPointDesc").attr("readonly",true);
		
				   $("#suitableStat").attr("disabled",true); 
				   $("#suitableContent").css("border","0px"); 
				   $("#suitableContent").attr("readonly",true);
				   $("#materialType").css("border","0px"); 
				   $("#materialType").attr("readonly",true);
				   $("#appraisalContent").css("border","0px"); 
				   $("#appraisalContent").attr("readonly",true);
				   $("#appraisalStat").attr("disabled",true); 
				   $("#appraisalContent").css("border","0px"); 
				   $("#appraisalContent").attr("readonly",true);
			    }
            }
	   );
   }
}

function regiProposalInfo(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if($.trim($("#titleName").val())==""){alert("제안명을 입력해주십시오.");return;}
	if($.trim($("#regiUserName").val())==""){alert("등록자명을 입력해주십시오.");return;}
	if($.trim($("#regiUserPhone").val())==""){alert("연락처를 입력해주십시오.");return;}
	if($.trim($("#regiUserEmail").val())==""){alert("이메일 정보를 입력해주십시오.");return;}
	var emailStr = $.trim($("#regiUserEmail").val());
	var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	if(!email_regex.test(emailStr)){ alert("메일주소가 잘못되었습니다. \n다시 입력해주세요."); return;}
	if($.trim($("#propPointDesc").val())==""){alert("주요내용을 입력해주십시오.");return;}
	if(!confirm("제안을 등록하겠습니까?")){
		return;
	}
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/insertProposalInfo.sys',
		{
			titleName:$.trim($("#titleName").val()),
			regiUserName:$.trim($("#regiUserName").val()),
			regiUserPhone:$.trim($("#regiUserPhone").val()),
			regiUserEmail:$.trim($("#regiUserEmail").val()),
			propPointDesc:$.trim($("#propPointDesc").val()),
			firstattachseq:$.trim($("#firstattachseq").val()),
			secondattachseq:$.trim($("#secondattachseq").val()),
			thirdattachseq:$.trim($("#thirdattachseq").val())
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("등록이 완료되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
}

function modiProposalInfo(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if($.trim($("#titleName").val())==""){alert("제안명을 입력해주십시오.");return;}
	if($.trim($("#regiUserName").val())==""){alert("등록자명을 입력해주십시오.");return;}
	if($.trim($("#regiUserPhone").val())==""){alert("연락처를 입력해주십시오.");return;}
	if($.trim($("#regiUserEmail").val())==""){alert("이메일 정보를 입력해주십시오.");return;}
	if($.trim($("#propPointDesc").val())==""){alert("주요내용을 입력해주십시오.");return;}
	var emailStr = $.trim($("#regiUserEmail").val());
	var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
	if(!email_regex.test(emailStr)){ alert("메일주소가 잘못되었습니다. \n다시 입력해주세요."); return;}  
	if(!confirm("수정한 제안정보를 저장하겠습니까?")){
		return;
	}
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/modifyProposalInfo.sys',
		{
		    receiptNum:$("#receiptNum").val(),
		    receiptNumStat:$("#receiptNumStat").val(),
			titleName:$.trim($("#titleName").val()),
			regiUserName:$.trim($("#regiUserName").val()),
			regiUserPhone:$.trim($("#regiUserPhone").val()),
			regiUserEmail:$.trim($("#regiUserEmail").val()),
			propPointDesc:$.trim($("#propPointDesc").val()),
			firstattachseq:$.trim($("#firstattachseq").val()),
			secondattachseq:$.trim($("#secondattachseq").val()),
			thirdattachseq:$.trim($("#thirdattachseq").val())
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("수정이 완료되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
}

function delProposalInfo(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if(!confirm("해당 제안을 삭제하겠습니까?")){
		return;
	}
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/delProposalInfo.sys',
		{
		    receiptNum:$("#receiptNum").val(),
		    receiptNumStat:$("#receiptNumStat").val()
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("삭제가 완료되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
}
function receProposalInfo(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if(!confirm("접수처리를 하겠습니까?")){
		return;
	}
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/receProposalInfo.sys',
		{
		   receiptNum:$("#receiptNum").val(),
		   receiptNumStat:$("#receiptNumStat").val()
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("접수가 완료되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
}

function revieProcess(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if($.trim($("#suitableStat").val())==""){alert("SKTS검토결과를 선택해주십시오.");return;}
	if($.trim($("#suitableContent").val())==""){alert("SKTS검토의견을 입력해주십시오.");return;}
	if($.trim($("#materialType").val())==""){alert("자재유형을 입력해주십시오.");return;}
	if($.trim($("#suggestTarget").val())==""){alert("제안대상을 선택해주십시오.");return;}
	if(!confirm("검토정보를 저장하겠습니까?")){ return; }
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/reviewProposalInfo.sys',
		{
		   receiptNum:$("#receiptNum").val(),
		   receiptNumStat:$("#receiptNumStat").val(),
		   suitableStat:$("#suitableStat").val(),
		   suitableContent:$("#suitableContent").val(),
		   materialType:$("#materialType").val(),
		   fourthattachseq:$("#fourthattachseq").val(),
		   suggestTarget:$("#suggestTarget").val()
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("검토정보가 저장되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
}

function finalProcess(){
	if($("#duplChk").val() == "1"){alert("처리중입니다.\n잠시만 기다려주십시오.\n시간지연시 새로고침 후 다시 시도해주십시오.");return;}
	if($.trim($("#appraisalStat").val())==""){alert("최종평가를 선택해주십시오.");return;}
	if($.trim($("#appraisalContent").val())==""){alert("최종평가의견을 입력해주십시오.");return;}
	if(!confirm("최종평가정보를 저장하겠습니까?")){
		return;
	}
	$("#duplChk").val("1");
	$.post
	( 
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/proposal/finalProposalInfo.sys',
		{
		   receiptNum:$("#receiptNum").val(),
		   receiptNumStat:$("#receiptNumStat").val(),
		   appraisalStat:$("#appraisalStat").val(),
		   appraisalContent:$("#appraisalContent").val()
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			if (result.success == true) {
				alert("최종평가정보가 저장되었습니다.");
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
				fnSearch();
			}else{
				alert(result.message);
				$("#duplChk").val("0");
				$('#proposalDetailPop').jqmHide();
				clearInputInfo();
			}
		}
	);
} 

function clearInputInfo(){
	$("#titleName").val("");
	$("#propStatus").val("");
	$("#regiUserName").val("");
	$("#regiDateTime").val("");
	$("#regiUserPhone").val("");
	$("#regiUserEmail").val("");
	$("#propPointDesc").val("");
	$("#firstattachseq").val("");
	$("#secondattachseq").val("");
	$("#thirdattachseq").val("");
	$("#suitableStat").val("");
	$("#suitableContent").val("");
	$("#materialType").val("");
	$("#fourthattachseq").val("");
	$("#appraisalStat").val("");
	$("#appraisalContent").val("");

	$("#propStatus").css("border","1px solid #aeaeae"); 
	$("#propStatus").attr("readonly",false);
	$("#regiDateTime").css("border","0px");
	$("#regiDateTime").attr("readonly",false);
	$("#titleName").css("border","1px solid #aeaeae"); 
	$("#titleName").attr("readonly",false);
	$("#regiUserName").css("border","1px solid #aeaeae"); 
	$("#regiUserName").attr("readonly",false);
	$("#regiUserPhone").css("border","1px solid #aeaeae"); 
	$("#regiUserPhone").attr("readonly",false);
	$("#regiUserEmail").css("border","1px solid #aeaeae"); 
	$("#regiUserEmail").attr("readonly",false);
	$("#propPointDesc").css("border","1px solid #aeaeae"); 
	$("#propPointDesc").attr("readonly",false);
	$("#firstattachseq").val("");
	$("#attach_file_name1").text("");
	$("#attach_file_path1").val("");
	$("#secondattachseq").val("");
	$("#attach_file_name2").text("");
	$("#attach_file_path2").val("");
	$("#thirdattachseq").val("");
	$("#attach_file_name3").text("");
	$("#attach_file_path3").val("");
	$("#fourthattachseq").val("");
	$("#attach_file_name4").text("");
	$("#attach_file_path4").val("");

	$("#suitableContent").css("border","1px solid #aeaeae"); 
	$("#suitableContent").attr("readonly",false);
	$("#materialType").css("border","1px solid #aeaeae"); 
	$("#materialType").attr("readonly",false);
	$("#appraisalContent").css("border","1px solid #aeaeae"); 
	$("#appraisalContent").attr("readonly",false);

	$("#regiJqmButton").hide();
	$("#modiJqmButton").hide();    
	$("#reviewJqmButton").hide();
	$("#finalJqmButton").hide();
	$("#delJqmButton").hide();
	$("#receJqmButton").hide();
}

function onlyNumberThis(event) {
	var key = window.event ? event.keyCode : event.which;
	if ((event.shiftKey == false) && ((key  > 47 && key  < 58) || (key  > 95 && key  < 106)
			|| key  == 35 || key  == 36 || key  == 37 || key  == 39  // 방향키 좌우,home,end  
			|| key  == 8  || key  == 46 || key  == 9 || key == 109 || key == 189) // del, back space, Tab, -
	) {
		return true;
	}else {
		return false;
	}    
};

function openReceiptPrint(){
	var oReport = GetfnParamSet($("#receiptNum").val()); 
	oReport.rptname = "proposalReport"; 
	oReport.param("receiptNum").value = $("#receiptNum").val(); 
	oReport.title = "자재제안정보"; // 제목 세팅
	oReport.open();
}


</script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
</head>
<body>
<div class="jqmWindow" id="proposalDetailPop">
<input type="hidden" id="duplChk" name="duplChk"/>
<input type="hidden" id="receiptNum" name="receiptNum"/>
<input type="hidden" id="receiptNumStat" name="receiptNumSta"/>
      <table width="800" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
               <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                  <tr>
        			 <td width="21"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" /></td>
        			 <td width="22"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px;" /></td>
                     <td class="popup_title">자재제안정보</td>
        			 <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                  </tr>
               </table>
                  <table width="100%"  border="0" cellpadding="0" cellspacing="0">
                  <tr>
                        <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
                        <td width="100%"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif" width="100%" height="20" /></td>
                        <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
                  </tr>
                  <tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<!-- todo : 처리상태에 따라 case 처리 -->
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FINAL_RESULT_PRINT">
								<tr>
									<td align="right">
										<a href="#"><img id="propPrintBtn" class="FINAL_RESULT_PRINT" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_printInfo.gif" style='border:0;' /></a>
									</td>
								</tr>
								<tr>
									<td style="height: 10px" class="FINAL_RESULT_PRINT" ></td>
								</tr>
							</table>
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="6" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">처리상태</td>
									<td class="table_td_contents4" colspan="5">
										<input type="hidden" id="propStatus" name="propStatus" value="" style="width: 100px"/>
                                        <table width="100%" border="1" cellpadding="0" cellspacing="0" style="border-collapse:collapse; border-color:#eaeaea; border-style:solid;">
	                                        <tr style="border:1px ; border-color:#eaeaea; border-bottom-style: solid;">
		                                        <td style="border-color:#eaeaea; border-right-style: solid; padding-top: 3px ;" width="25%" align="center" bgcolor="#eaf4fd"><font color="#2e6e9e"><b><span id="stepTitle1"></span></b></font></td>
												<td style="border-color:#eaeaea; border-right-style: solid; padding-top: 3px ;" width="25%" align="center" bgcolor="#eaf4fd"><font color="#2e6e9e"><b><span id="stepTitle2"></span></b></font></td>
		                                        <td style="border-color:#eaeaea; border-right-style: solid; padding-top: 3px ;" width="25%" align="center" bgcolor="#eaf4fd"><font color="#2e6e9e"><b><span id="stepTitle3"></span></b></font></td>
												<td style="border-color:#eaeaea; border-right-style: solid; padding-top: 3px ;" width="25%" align="center" bgcolor="#eaf4fd"><font color="#2e6e9e"><b><span id="stepTitle4"></span></b></font></td>
	                                        </tr>
	                                        <tr style="border:1px ; border-color:#eaeaea; border-bottom-style: solid;">
		                                        <td style="border-color:#eaeaea; border-right-style: solid;" width="25%" align="center"><span id="stepStatus1"></span></td>
												<td style="border-color:#eaeaea; border-right-style: solid;" width="25%" align="center"><span id="stepStatus2"></span></td>
		                                        <td style="border-color:#eaeaea; border-right-style: solid;" width="25%" align="center"><span id="stepStatus3"></span></td>
												<td style="border-color:#eaeaea; border-right-style: solid;" width="25%" align="center"><span id="stepStatus4"></span></td>
	                                        </tr>
                                        </table>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">제안명</td>
									<td class="table_td_contents4" colspan="5"><input type="text" id="titleName" name="titleName" value="" style="width: 225px" maxlength="100"/></td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">제안자</td>
									<td class="table_td_contents4"><input type="text" id="regiUserName" name="regiUserName" value="" style="width: 100px" maxlength="15"/></td>
									<td class="table_td_subject" width="110" align="center">제안일</td>
									<td class="table_td_contents4"><input type="text" id="regiDateTime" name="regiDateTime" value="" style="width: 100px"/></td>
									<td class="table_td_subject" width="110" align="center">연락처</td>
									<td class="table_td_contents4"><input type="text" id="regiUserPhone" name="regiUserPhone" value="" style="width: 100px" maxlength="50" onkeydown="return onlyNumberThis(event)"/></td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">e-mail</td>
									<td class="table_td_contents4"><input type="text" id="regiUserEmail" name="regiUserEmail" value="" style="width: 100px" maxlength="100" style="ime-mode:disabled;"/></td>
									<td class="table_td_subject" width="110" align="center">주요내용</td>  
									<td class="table_td_contents4" colspan="3"><input type="text" id="propPointDesc" name="propPointDesc" value="" style="width: 355px" maxlength="3000"/></td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">작성가이드</td>
									<td class="table_td_contents4" colspan="5" align="left">
										<table border="0" cellspacing="0" cellpadding="0" style="width: 430px">
											<tr>
												<td align="center">
													<br/><b>[작성할 시 필요한 주요 항목(권장)]</b><br/><br/>
												</td>
											</tr>
											<tr>
												<td>
													ο 상품명 : 통용되는 용어
												</td>
											</tr>
											<tr>
												<td>
													ο 상품규격 : 가로/세로/높이/무게/길이(m,mm등)/색상/재질/타입 등
												</td>
											</tr>
											<tr>
												<td>
													ο 제안목적 : 제안목적 기입
												</td>
											</tr>
											<tr>
												<td>
													ο 제안유형 : 원가절감/성능개선 등
												</td>
											</tr>
											<tr>
												<td>
													ο 예상단가 : 단위 당 예상단가 기입
												</td>
											</tr>
											<tr>
												<td>
													ο 비용절감금액 : 제안상품이 상용됨으로써 절감되는 금액(월 또는 연단위)
												</td>
											</tr>
											<tr>
												<td>
													ο 기대효과 : 비용절감 外 기대되는 효과
												</td>
											</tr>
											<tr>
												<td>
													ο 특허발급여부 : 특허취득(특허번호기입)/출원 준비중/모름
												</td>
											</tr>
											<tr>
												<td>
													ο 저작권발급 : 저작권획득(저작권번호기입)/상표획득/모름
												</td>
											</tr>
											<tr>
												<td>
													ο 상세설명 : 제안상품에 대한 상세설명(글, 사진, 이미지 모두 가능)
												</td>
											</tr>
											<tr>
												<td>
													ο 요청사항 : SK텔레시스 및 SK브로드밴드에 제안상품에 대한 요청사항<br/><br/>
												</td>
											</tr>
											<tr>
												<td>
													<font color="red"><b>
													※ 자유형식(파워포인트)으로 상기 항목을 작성한 후 첨부 요망<br/>
													※ 상품이미지 및 시험성적서 첨부 요망<br/>
													</b></font>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="110" align="center">첨부파일<br/>(제안자)</td>
									<td colspan="5" style="margin: 0px">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" >
											<tr>
												<td bgcolor="#dbeaf7" align="center" style="width: 100px"><b>PPT 파일</b><br/><font color="red">(제한용량 5MB)</font></td>
												<td bgcolor="#dbeaf7" align="left" style="width: 67px" class="FileTdInDiv1">
					                                <a href="#">
					                                    <img id="btnAttach1" name="btnAttach1" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
					                                </a>
												</td>
												<td class="table_td_contents4">
					                                <input type="hidden" id="firstattachseq" name="firstattachseq" value="" /><input type="hidden" id="attach_file_path1" name="attach_file_path1" value="" />
					                                <a href="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
					                                    <span id="attach_file_name1"></span>
					                                </a>
												</td>
											</tr>
											<tr>
												<td colspan="3" height='1' bgcolor="eaeaea"></td>
											</tr>
											<tr>
												<td bgcolor="#dbeaf7" align="center" style="width: 100px"><b>첨부 파일1</b><br/><font color="red">(제한용량 5MB) </font></td>
												<td bgcolor="#dbeaf7" align="left" style="width: 67px" class="FileTdInDiv1">
					                                <a href="#">
					                                    <img id="btnAttach2" name="btnAttach2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
					                                </a> 
												</td>
												<td class="table_td_contents4">
					                                <input type="hidden" id="secondattachseq" name="secondattachseq" value="" /><input type="hidden" id="attach_file_path2" name="attach_file_path2" value="" />
					                                <a href="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
					                                    <span id="attach_file_name2"></span>
					                                </a>
												</td>
											</tr>
											<tr>
												<td colspan="3" height='1' bgcolor="eaeaea"></td>
											</tr>
											<tr>
												<td bgcolor="#dbeaf7" align="center" style="width: 100px"><b>첨부 파일2</b><br/><font color="red">(제한용량 5MB)</font></td>
												<td bgcolor="#dbeaf7" align="left" style="width: 67px" class="FileTdInDiv1">
					                                <a href="#">
					                                    <img id="btnAttach3" name="btnAttach3" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
					                                </a>
												</td>
												<td class="table_td_contents4">
					                                <input type="hidden" id="thirdattachseq" name="thirdattachseq" value="" /><input type="hidden" id="attach_file_path3" name="attach_file_path3" value="" />
					                                <a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
					                                    <span id="attach_file_name3"></span>
					                                </a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr class="SKTS_RESULT">
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr class="SKTS_RESULT">
									<td class="table_td_subject" width="110" align="center">검토자</td>
									<td class="table_td_contents" id="suggestTargetName">
<!-- 										<input type="text" id="suggestTargetName" name="suggestTargetName" value=""/> -->
									</td>
									<td class="table_td_subject" width="110" align="center">검토자 연락처</td>
									<td class="table_td_contents" id="suitableMobile">
<!-- 										<input type="text" id="suitableMobile" name="suitableMobile" value=""/> -->
									</td>
									<td class="table_td_subject" width="110" align="center">제안대상</td>
									<td class="table_td_contents">
										<select id="suggestTarget" name="suggestTarget" class="select">
											<option value="">선택하세요.</option>
										</select>
									</td>
								</tr>
								<!-- todo : 처리상태에 따라 case 처리 -->
								<tr class="SKTS_RESULT">
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr class="SKTS_RESULT">
									<td class="table_td_subject" width="110" align="center">SKTS검토결과</td>
									<td class="table_td_contents4">
										<select class="select" id="suitableStat" style="width: 100px">
											<option value="">선택</option>
											<option value="31">적합</option>
											<option value="32">부적합</option>
										</select>
									</td>
									<td class="table_td_subject" width="110" align="center">SKTS검토의견</td>
									<td class="table_td_contents4" colspan="3"><input type="text" id="suitableContent" name="suitableContent" value="" style="width: 355px" maxlength="3000"/></td>
								</tr>
								<tr class="SKTS_RESULT">
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr class="SKTS_RESULT">
									<td class="table_td_subject" width="110" align="center">자재유형</td>
									<td class="table_td_contents4"><input type="text" id="materialType" name="materialType" value="" style="width: 100px" maxlength="50"/></td>
									<td class="table_td_subject" width="110" align="center">첨부파일(SKTS)</td>
									<td colspan="3" style="margin: 0px">
										<table width="100%" border="0" cellspacing="0" cellpadding="0" >
											<tr>
												<td bgcolor="#dbeaf7" align="center" style="width: 1px" class="FileTdInDiv2">&nbsp;<br/>&nbsp;</td>
												<td bgcolor="#dbeaf7" align="left" style="width: 67px" class="FileTdInDiv2">
					                                <a href="#">
					                                    <img id="btnAttach4" name="btnAttach4" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_fileRegister.gif" style="border: 0px" />
					                                </a>
												</td>
												<td class="table_td_contents4">
					                                <input type="hidden" id="fourthattachseq" name="fourthattachseq" value="" /><input type="hidden" id="attach_file_path4" name="attach_file_path4" value="" />
					                                <a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
					                                    <span id="attach_file_name4"></span>
					                                </a>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr class="FINAL_RESULT">
									<td colspan="6" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr class="FINAL_RESULT">
									<td class="table_td_subject" width="110" align="center">최종평가</td>
									<td class="table_td_contents4">
										<select class="select" id="appraisalStat" style="width: 100px">
											<option value="">선택</option>
											<option value="41">채택</option>
											<option value="42">미채택</option>
										</select>
									</td>
									<td class="table_td_subject" width="110" align="center">최종평가의견</td>
									<td class="table_td_contents4" colspan="3"><input type="text" id="appraisalContent" name="appraisalContent" value="" style="width: 355px" maxlength="3000"/></td>
								</tr>


								<tr>
									<td colspan="6" class="table_top_line"></td>
								</tr>
							</table> 
							<table width="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="center">
									<a href="#"><img id="regiJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" style='border:0;' /></a>
									<a href="#"><img id="modiJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_modify.gif" style='border:0;' /></a>
									<a href="#"><img id="reviewJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif" style='border:0;' /></a>
									<a href="#"><img id="finalJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif" style='border:0;' /></a>
									<a href="#"><img id="delJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_delete.gif" style='border:0;' /></a>
									<a href="#"><img id="receJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_info_rece.gif" style='border:0;' /></a>
									<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;' /></a>
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
               </table></td>
         </tr>
      </table>

   </div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>