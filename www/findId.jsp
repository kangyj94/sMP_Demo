<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
$(document).ready(function() {
	$("#closeButton").click(function(){	//닫기
		window.close();
	});
	$("#forwardButton").click(function(){	//전송버튼
		fnIdFind();
	});
	$("#loginDialogPop").jqm().jqDrag("#dialogHandle"); 
});

function fnIdFind() {
	var srcUserNm = $.trim($("#srcUserNm").val());
	var srcMobileNum = $.trim($("#srcMobileNum1").val())+''+$.trim($("#srcMobileNum2").val())+''+$.trim($("#srcMobileNum3").val())+'';
		if(srcUserNm.length==0){
			alert("성명을 입력해 주십시오.");
			return;
		}
		if($.trim($("#srcMobileNum1").val()).length==0){
			alert("핸드폰번호를 입력해 주십시오.");
			return;
		}
		if($.trim($("#srcMobileNum2").val()).length==0){
			alert("핸드폰번호를 입력해 주십시오.");
			$("#srcMobileNum2").focus();
			return;
		}
		if($.trim($("#srcMobileNum3").val()).length==0){
			alert("핸드폰번호를 입력해 주십시오.");
			$("#srcMobileNum3").focus();
			return;
		}
	$.post(
			"<%=Constances.SYSTEM_CONTEXT_PATH %>/common/userIdPasswordFind.sys", 
			{ srcUserNm:srcUserNm, srcMobileNum:srcMobileNum,srcType:"id"},
			function(arg){
				var result = eval('(' + arg + ')').customResponse;
				var errors = "";
				if (result.success == false) {
					for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
					$("#srcUserNm").val('');
					$("#srcMobileNum1").val('');
					$("#srcMobileNum2").val('');
					$("#srcMobileNum3").val('');
					$("#srcUserNm").focus();
					alert(errors);
				} else {
					for (var i = 0; i < result.message.length; i++) { errors +=  result.message[i]; }
					alert(errors);
					window.close();
				}
			}
		);
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
								<span id="idCheckSpan">
									아이디 찾기
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
							<table id="idDiv1" width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td width="15" height="27" valign="top" >
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bullet_stitle_red.gif" width="5" height="5" class="bullet_stitle" />
									</td>
									<td class="txt_notice_red">입력정보가 정확해야 휴대전화로 아이디가 전송됩니다.</td>
								</tr>
							</table>
							<!-- 타이틀 끝 -->
							<!-- 컨텐츠 시작 -->
							<table id="idDiv1" width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" class="table_top_line_red"></td>
								</tr>
								<tr>
									<td class="table_td_subject_red">성명</td>
									<td class="table_td_contents">
										<input id="srcUserNm" name="srcUserNm" type="text" value="" maxlength="10" style="width:143px" class="blue"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject_red" width="80">휴대폰</td>
									<td class="table_td_contents">
										<select id="srcMobileNum1" name="srcMobileNum1" class="input_select">
											<option value="" selected="selected">선택</option>
											<option value="010">010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
										</select> -
									<input name="srcMobileNum2" id="srcMobileNum2" type="text" class="blue" size="4" maxlength="4" /> -
									<input name="srcMobileNum3" id="srcMobileNum3" type="text" class="blue" size="4" maxlength="4" />
									</td>
								</tr>
								<tr> 
									<td colspan="2" class="table_top_line_red"></td>
								</tr>
							</table>
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/blank.gif" width='100%' height="10" class="space"/>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#"><img id="forwardButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_ok.gif" height="23" border="0"/></a>
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
</body>
</html>