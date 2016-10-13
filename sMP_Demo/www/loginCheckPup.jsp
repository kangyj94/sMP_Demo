<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 400px;
    
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

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	$("#srcMoblieNum").css("ime-mode", "disabled");
	$("#srcAuthNum").css("ime-mode", "disabled");
	
	$("#srcAuthNum").keydown(function(e){
		if(e.keyCode==13) { $("#selectButton").click(); }
	});
	$("#selectButton").click(function(){	//선택
		fnJqmInputAuth();
	});
	$("#reMobileNum").click(function(){
		fnJqmReMobileNum();
	});
	$("#closeButton").click(function(){	//Dialog 닫기
		$("#loginDialogPop").jqmHide();
	});
	$("#loginDialogPop").jqm().jqDrag("#dialogHandle"); 
});

var _authFlag = "1";
function fnJqmAuthInit(mobileParam) {
	$("#srcMoblieNum").val(mobileParam);
	$("#srcAuthNum").val('');
	$("#srcAuthNum").focus();
	_authFlag = "1";
}

function fnJqmInputAuth() {
	var loginId = $.trim($("#loginId").val());
	var srcMoblieNum = $.trim($("#srcMoblieNum").val());
	var srcAuthNum = $.trim($("#srcAuthNum").val());
	var srcAreaType = $("#srcAreaTypeDiv").val();
	
	if((_authFlag=="1" || _authFlag=="3") && srcAuthNum.length==0) {
		alert("인증번호을 입력해 주십시오!");
		$("#srcAuthNum").val(srcAuthNum);
		$("#srcAuthNum").focus();
		return;
	}
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/system/loginAuthCheck.sys", 
		{ authFlag:_authFlag, loginId:loginId, srcMoblieNum:srcMoblieNum, srcAuthNum:srcAuthNum },
		function(arg){
			var result = eval('(' + arg + ')').customResponse;
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
				$("#srcAuthNum").val('');
				$("#srcAuthNum").focus();
			} else {
				$('#loginDialogPop').jqmHide();
				if(result.newIdx) {

					fnContractToDoList(result.newIdx);

<%-- 계약서 계약 팝업 주석처리
					fnLogin();
--%>
				} else {
					fnLogin();
				}
			}
		}
	);
}

function fnJqmReMobileNum() {
	$("#chk_flag").val("1");
	$("#enter").click();

	$("#reMobileNumTxt").text('  처리중...');
	$("#reMobileNum").hide();
	setTimeout(fnReMobileNumDisplay,1000*180);
}

function fnReMobileNumDisplay() {
	$("#reMobileNumTxt").text('');
	$("#reMobileNum").show();
}
</script>
</head>

<body>
<div class="jqmWindow" id="loginDialogPop">
	<table width="400"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="dialogHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif');">
						<tr>
							<td width="21">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_left.gif" width="21" height="47" />
							</td>
							<td width="22">
								<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px "/>
							</td>
							<td class="popup_title">
								<span id="loginCheckSpan">
								모바일인증
								</span>
							</td>
							<td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_right.gif');">&nbsp;</td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20"/>
						</td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<!-- 타이틀 시작 -->
							<table id="mobileDiv1" width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="15" height="27" valign="top" >
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
									</td>
									<td class="txt_notice_red">
										휴대폰 번호는 사용자 등록 시 입력된 번호입니다.<br/>변경되었을 경우 관리자에게 문의하십시오
									</td>
								</tr>
								<tr>
									<td width="15" height="27" valign="top" >
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
									</td>
									<td class="txt_notice_red">
										[인증번호받기] 버튼을 누르시면 3분 후 <br/>[인증번호받기]가 활성화 됩니다.
									</td>
								</tr>
							</table>
							<!-- 타이틀 끝 -->
							<!-- 컨텐츠 시작 -->
							<table id="mobileDiv2" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">휴대폰</td>
									<td class="table_td_contents">
										<input id="srcMoblieNum" name="srcMoblieNum" type="text" value="" maxlength="11" style="width:120px;vertical-align: middle;" class="input_text_none" readonly="readonly"/>
										<span id="reMobileNumTxt"></span>
										<a href="#">
										<img id="reMobileNum" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_phone2.gif" width="82" height="18" style="border:0; vertical-align: middle;" />
										</a>
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject">인증번호</td>
									<td class="table_td_contents">
										<input id="srcAuthNum" name="srcAuthNum" type="password" value="" maxlength="4" style="width:80px" class="blue"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#"><img id="selectButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/popup_btn_reg.gif" height="23" border="0"/></a>
										<a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/popup_btn_cancel.gif" height="23" border="0"/></a>
									</td>
								</tr>
							</table>
							<!-- 컨텐츠 끝 -->
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>

<div class="jqmWindow" id="ContractDialogPop">

</div>
</body>
</html>