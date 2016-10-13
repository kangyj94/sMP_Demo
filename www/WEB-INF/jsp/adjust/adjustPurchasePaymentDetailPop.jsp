<%@page import="kr.co.bitcube.common.dto.UserDto"%>
<%@page import="kr.co.bitcube.adjust.dto.AdjustDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
   String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String crea_buyi_date = CommonUtils.getCurrentDate();
	AdjustDto detailInfo = (AdjustDto)request.getAttribute("detailInfo");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="text/css">
.sumupContent {
	width:95%;
/*     direction:rtl; */
	display:block;
	max-width:100%;
	line-height:1.5;
	padding:15px 15px 30px;
	border-radius:3px;
	border:1px solid #85b5d9;
/* 	font:13px Tahoma, cursive; */
	transition:box-shadow 0.5s ease;
	box-shadow:0 4px 6px rgba(0,0,0,0.1);
/*     font-smoothing:subpixel-antialiased; */
/*     background:linear-gradient(#F9EFAF, #F7E98D); */
/*     background:-o-linear-gradient(#F9EFAF, #F7E98D); */
/*     background:-ms-linear-gradient(#F9EFAF, #F7E98D); */
/*     background:-moz-linear-gradient(#F9EFAF, #F7E98D); */
/*     background:-webkit-linear-gradient(#F9EFAF, #F7E98D); */
}
</style>
<script type="text/javascript">
$(document).ready(function(){
   $("#buyi_tota_amou").val($.number("<%=detailInfo.getBuyi_tota_amou()%>") + " 원");
   $("#none_paym_amou").val($.number("<%=detailInfo.getNone_paym_amou()%>") + " 원");
   $("#pay_amou").focus();
   $("#regButton").click(function() { fnApply(); });
   $("#payDate").val('<%=crea_buyi_date%>');
   $("#sumupRegButton").click(function() { updateSumupContent(); });
   
});

function fnApply(){
   	var none_paym_amou = parseInt($.number("<%=detailInfo.getNone_paym_amou()%>").replace(/,/g,""));
   	var pay_amou = $.trim($("#pay_amou").val()); 
   	var payDate = $("#payDate").val();
   
   	if(parseInt(none_paym_amou) < parseInt(pay_amou)){
   		$("#dialog").html("<font size='2'>출금금액이 미출금금액보다 많습니다.</font><br><br><font size='2'>확인후 다시 입력해주세요.</font>");
      	$("#dialog").dialog({
        	title: 'Fail',modal: true,
         	buttons: {"Ok": function(){$(this).dialog("close");} }
      	});         
      	$("#pay_amou").focus();
      	return;     	   
   	}    
   	
    if(pay_amou == ""){
    	$("#dialog").html("<font size='2'>출금금액을 입력해주세요.</font>");
       	$("#dialog").dialog({
        	title: 'Fail',modal: true,
          	buttons: {"Ok": function(){$(this).dialog("close");} }
       	});        
       	$("#pay_amou").focus();
       	return;     
    }
     
	if(payDate == ""){
     	$("#dialog").html("<font size='2'>출금일자를 입력해주세요.</font>");
        $("#dialog").dialog({
        	title: 'Fail',modal: true,
           	buttons: {"Ok": function(){$(this).dialog("close");} }
        });         
        $("#payDate").focus();
        return;     
    }      	

	if(!confirm("등록하시겠습니까?"))return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/savePaymentDetail.sys", 
		{
			oper:"add",
			pay_amou:pay_amou,
			buyi_sequ_numb:'<%=detailInfo.getBuyi_sequ_numb()%>',
			none_paym_amou:none_paym_amou,
			payDate:payDate
		},
		function(arg){ 
			if(fnAjaxTransResult(arg)) {  //성공시
//             	var opener = window.dialogArguments;
				window.opener.$("#list").trigger("reloadGrid");
				window.close();
			}
		}
	);
}

//날짜 조회 및 스타일
$(function(){
	$("#payDate").datepicker({
		showOn: "button",
		buttonImage: "/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

//적요내역 등록
function updateSumupContent(){
	var sumupContent = $("#sumupContent").val();
	if(sumupContent == ""){
		$("#dialog").html("<font size='2'>적요내역을 등록 하여 주십시오.</font>");
		$("#dialog").dialog({
			title: 'Fail',modal: true,
			buttons: {"Ok": function(){$(this).dialog("close");} }
		});
		$("#sumupContent").focus();
		return;
	}
	if(!confirm("등록하시겠습니까?"))return;
	$.post(
		"/adjust/updateSumupContent/save.sys",
		{
			oper:"edit",
			buyiSequNumb:'<%=detailInfo.getBuyi_sequ_numb()%>',
			sumupContent:sumupContent
		},
		function(arg){
			if(fnAjaxTransResult(arg)) {  //성공시
				window.opener.$("#list").trigger("reloadGrid");
				window.close();
			}
		}
	);
	
}
</script>

</head>
<body>
<table>
	<tr>
		<td>
			<table width="760" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
							<tr>
								<td width="21">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" style="width: 21px; height: 47px;" />
								</td>
								<td width="22">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" style="width: 14px; height: 13px; margin-bottom: 5px;" />
								</td>
								<td class="popup_title">매입출금내역</td>
								<td width="10" style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif);">&nbsp;</td>
							</tr>
						</table>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" >
							<tr>
								<td width="20" height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" style="width: 20px; height: 20px;" />
								</td>
								<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);">&nbsp;</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" style="width: 20px; height: 20px;" />
								</td>
							</tr>
							<tr>
								<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);">&nbsp;</td>
								<td valign="top" bgcolor="#FFFFFF">
									<!-- 컨텐츠 시작 -->
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
										<tr>
											<td class="table_td_subject9" width="110">공급사명</td>
											<td class="table_td_contents">
												<%=CommonUtils.getString(detailInfo.getVendorNm()) %>
											</td>
											<td class="table_td_subject9">전표번호</td>
											<td class="table_td_contents">
												<%=CommonUtils.getString(detailInfo.getSap_jour_numb()) %>
											</td>
										</tr>
										<tr>
											<td colspan="4" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject9">매입합계</td>
											<td class="table_td_contents">
												<input id="buyi_tota_amou" name="buyi_tota_amou" type="text" value="<%=CommonUtils.getString(detailInfo.getBuyi_tota_amou()) %>" size="" maxlength="50" style="width: 50%;" class="input_none" readonly="readonly" />
											</td>
											<td class="table_td_subject">출금일자</td>
											<td class="table_td_contents">
												<input type="text" name="payDate" id="payDate" style="width: 90px; vertical-align: middle;" />
											</td>
										</tr>
										<tr>
											<td colspan="4" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td class="table_td_subject9">미출금금액</td>
											<td class="table_td_contents">
												<input id="none_paym_amou" name="none_paym_amou" type="text" value="<%=CommonUtils.getString(detailInfo.getNone_paym_amou()) %>" size="" maxlength="50" style="width: 50%;" class="input_none" readonly="readonly" />
											</td>
											<td class="table_td_subject">출금금액</td>
											<td class="table_td_contents" colspan="3">
												<input id="pay_amou" name="pay_amou" type="text" value="" size="" maxlength="15" style="width: 100%" class="blue" onkeydown="return onlyNumberForSum(event);"/>
											</td>
										</tr>
										<tr>
											<td colspan="4" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
									</table>
								</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 95px;" />
								</td>
							</tr>
							<tr>
								<td width="20" height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif" style="width: 20px; height: 50px;" />
								</td>
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 27px;">
										<tr>
											<td align="center">
												<a href="#"> 
													<img id="regButton" name="regButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" style="width: 65px; height: 23px; border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
												</a> 
											</td>
										</tr>
									</table>
								</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 50px;" />
								</td>
							</tr>
							<tr style="height: 1px;">
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" style="width: 20px; height: 20px;" />
								</td>
								<td style="background-image: url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);">&nbsp;</td>
								<td height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" style="width: 20px; height: 20px;" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="10"></td>
	</tr>
	<tr>	
		<td>
			<table width="760" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
							<tr>
								<td width="21">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" style="width: 21px; height: 47px;" />
								</td>
								<td width="22">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" style="width: 14px; height: 13px; margin-bottom: 5px;" />
								</td>
								<td class="popup_title">적요내역</td>
								<td width="10" style="background-image:url( <%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif);">&nbsp;</td>
							</tr>
						</table>
						<table width="100%" border="0" cellpadding="0" cellspacing="0" >
							<tr>
								<td width="20" height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" style="width: 20px; height: 20px;" />
								</td>
								<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif);">&nbsp;</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" style="width: 20px; height: 20px;" />
								</td>
							</tr>
							<tr>
								<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif);">&nbsp;</td>
								<td valign="top" bgcolor="#FFFFFF">
									<table width="100%" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
										<tr>
											<td class="table_td_subject" width="90">적 요</td>
											<td class="table_td_contents" style="height: 90px;">
												<textarea id="sumupContent" class="sumupContent"></textarea>
											</td>
										</tr>
										<tr>
											<td colspan="4" height='1' bgcolor="eaeaea"></td>
										</tr>
										<tr>
											<td colspan="4" class="table_top_line"></td>
										</tr>
									</table>
								</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 95px;" />
								</td>
							</tr>
							<tr>
								<td width="20" height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif" style="width: 20px; height: 30px;" />
								</td>
								<td>
									<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height: 27px; padding-top: 7px">
										<tr>
											<td align="center">
												<a href="#"> 
													<img id="sumupRegButton" name="sumupRegButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" style="width: 65px; height: 23px; border: 0px;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />
												</a> 
											</td>
										</tr>
									</table>
								</td>
								<td width="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 30px;" />
								</td>
							</tr>
							<tr style="height: 1px;">
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" style="width: 20px; height: 20px;" />
								</td>
								<td style="background-image: url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif);">&nbsp;</td>
								<td height="20">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" style="width: 20px; height: 20px;" />
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" style="padding-top: 10px ">
			<a href="#"> 
				<img id="closeButton" name="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="width: 65px; height: 23px; border: 0px;" onclick="javaScript:window.close();"/>
			</a>
		</td>
	</tr>
</table>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</body>
</html>