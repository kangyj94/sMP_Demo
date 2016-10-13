<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>OK Plaza에 오신것을 환영합니다.</title>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>


<%
	if(Constances.COMMON_ISREAL_SERVER){
%>

<%
/**------------------------------------공인인증 등록---------------------------------
 * 파라미터1 : 법인 (CLT), 공급사 (VEN)
 * 파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
 * 파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
 * 파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 "" 으로 넘긴다.)
 * 파라미터5 : CallBack function명
 * 파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId)
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
function fnAuth(){
	var frm = document.frm;
	if(frm.basicChk[0].checked == true && frm.individualChk[0].checked == true){
		$("#popup_titlebar_bullet").attr("src","/img/homepage/red_titlebar_bullet.gif");
		$("#popup_titlebar_mid").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif)');
		$("#popup_titlebar_left").attr("src","/img/homepage/red_titlebar_left.gif");
		$("#popup_titlebar_right").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_right.gif)');
		$("#divTitleName").attr("color", "white");
		$("#btnAuthRegDiv").attr("src","/img/homepage/popup_btn_reg.gif");
		$("#btnAuthManageCloseDiv").attr("src","/img/homepage/popup_btn_cancel.gif");		
		fnAuthBusinessNumberDialog("CLT", "REG", '0', "", "fnCallBackAuthBusinessNumber", "");
	}else{
		alert("약관에 동의하셔야 가입등록을 진행 할 수 있습니다.");
	}
}
/**
 * 공인인증 확인후 다음단계 페이지로 포워딩
 */
function fnCallBackAuthBusinessNumber(userDn) {
	if(userDn != "" && userDn != null){
		$("#userDn").val(userDn);
		$("#setUserDn").val(userDn);
		$("#setBusinessNum").val($("#businessNum").val());
		chk();
		
		//-----------------계약서 체결---------------------
//		물품공급 계약서 작업
// 		//chk();
// 		$.post(
// 			"/system/contractRegist.sys",
// 			{ svcTypeCd:'BUY', businessNum:$("#businessNum").val(), contract_userNm:$("#contract_userNm").val(), contract_version:'1.1' },
// 			function(arg){
// 				if(fnTransResult(arg, false)) {
// 					var result = eval('(' + arg + ')').customResponse;
// 					if (result.success == false) {
// 						chk();
// 					} else {
// 						alert("계약체결이 완료 되었습니다.\n로그인 하십시오!");
// 						location.href="/index.jsp";
// 					}
// 				}
// 			}
// 		);
	}
}
</script>
<%
	}else{
%>
<script type="text/javascript">
function fnAuth(){
	var frm = document.frm;
	if(frm.basicChk[0].checked == true && frm.individualChk[0].checked == true){
		chk();
	}else{
		alert("약관에 동의하셔야 가입등록을 진행 할 수 있습니다.");
	}
}
</script>
<%
	}
%>

<% //------------------------------------------------------------------------------ %>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function chk(check) {
	var frm = document.frm;
	frm.action = "/homepage/member/requestClient.home";
	frm.submit();
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	contractDetailList();
});

//물품공급계약서 받아오기
function contractDetailList(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/common/memberJoinContractlist.sys",
		{
			contractVersion:1,
			contractClassify:"BUY"
		},
		function(arg){
			var list = eval('(' + arg + ')').contractDetailList;
			for(var i=0; i<list.length; i++){
				if(list[i].contractVersion.indexOf("B") >= 0){
					$("#basicContractContents").append(list[i].contractContents);
					$("#basicContractVersion").val(list[i].contractVersion);
					$("#basicContractClassify").val(list[i].contractClassify);
				}else if(list[i].contractVersion.indexOf("I") >= 0){
					$("#individualContractContents").append(list[i].contractContents);
					$("#individualContractVersion").val(list[i].contractVersion);
					$("#individualContractClassify").val(list[i].contractClassify);
				}
				
			}
		}
	);
}
</script>

</head>
<body>
<form id="frm" name="frm" method="post">
	<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<input type="hidden" id="basicContractVersion" name="basicContractVersion" value=""/>
				<input type="hidden" id="basicContractClassify" name="basicContractClassify" value=""/>
				<input type="hidden" id="individualContractVersion" name="individualContractVersion" value=""/>
				<input type="hidden" id="individualContractClassify" name="individualContractClassify" value=""/>
			</td>
		</tr>
		<tr>
			<td align="center" height="101px">
			<input id="setUserDn" name="setUserDn" type="hidden"/>
			<input id="setBusinessNum" name="setBusinessNum" type="hidden"/>
			<!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 --></td>
		</tr>

		<tr>
			<td align="center"><!-- 메인 컨텐츠 시작-->
				<table width="977" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
							<!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_06.jsp"%><!-- 좌측메뉴 끝-->
						</td>
						<td width="34" valign="top">&nbsp;</td>
						<td width="757" valign="top">
						<!-- 메인 컨텐츠 내용 시작-->
							<table width="757px" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_06.gif" width="757" height="63" /></td>
								</tr>
								<tr>
									<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_st_01_01.gif" width="300" height="38" /></td>
									<td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11" /> Home &gt;<span class="orange"> 구매사 회원가입</span></td>
								</tr>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19" /></td>
								</tr>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/join_txt_01.gif" width="757" height="48" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/b_contract.gif" width="757" height="45" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td width='100%' class='pcontent' colspan="2" align="left">
										<div id="basicContractContents" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:730px; height:240px;; padding:10px 10px 10px 10px;" >
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2"> 
										<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"">
											<tr>
												<td align="center">
													<input type="radio" id="basicChk" name="basicChk" value="1" class="input_none" />
														동의합니다.
												</td>
												<td align="center">
													<input type="radio" id="basicChk" name="basicChk" value="2" class="input_none" />
														동의 하지 않습니다.
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/i_contract.gif" width="757" height="45" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td width='100%' class='pcontent' colspan="2" align="left">
										<div id="individualContractContents" style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:730px; height:240px;; padding:10px 10px 10px 10px;" >
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2" align="left">
										<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" >
											<tr>
												<td align="center">
													<input type="radio" id="individualChk" name="individualChk" value="1" class="input_none" />
														동의합니다.
												</td>
												<td align="center">
													<input type="radio" id="individualChk" name="individualChk" value="2" class="input_none" />
														동의 하지 않습니다.
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2" align="center" >
										<a href="#">
											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_next.gif" width="85" height="22" border="0" onclick="fnAuth()"/>
										</a>
<!-- 										<a href="/BuyContractDownload.docx">  -->
<%-- 											<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_agreementDownload.gif" border="0"/> --%>
<!--  										</a> -->
									</td>
								</tr>
							</table>            
							<!-- 메인 컨텐츠 내용 끝-->
						</td>
					</tr>
				</table>
				<!-- 메인 컨텐츠 끝-->
			</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
		</tr>
	</table>
</form>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</body>
</html>