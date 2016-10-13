<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-245 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
	
	String contractCookie = (String)request.getAttribute("contractCookie");
	
	boolean result = Boolean.parseBoolean(request.getAttribute("result").toString());
	
	String basicContractContents = "";
	String individualContractContents = "";
	String specialContractContents = "";
	String basicContractVersion = "";
	String individualContractVersion = "";
	String specialContractVersion = "";
	String basicContractClassify = "";
	String individualContractClassify = "";
	String specialContractClassify = "";
	String businessNum = "";
	String registNum = "";
	List<Map<String, Object>> contractDetailList = (List<Map<String, Object>>)request.getAttribute("contractDetailList");
	if(contractDetailList != null){
		for(int idx=0; idx < contractDetailList.size(); idx++){
			if(contractDetailList.get(idx).get("contractVersion").toString().indexOf("B") >= 0){
				basicContractContents = (String)contractDetailList.get(idx).get("contractContents");
				basicContractVersion = (String)contractDetailList.get(idx).get("contractVersion");
				basicContractClassify = (String)contractDetailList.get(idx).get("contractClassify");
			}else if(contractDetailList.get(idx).get("contractVersion").toString().indexOf("I")>=0){
				individualContractContents = (String)contractDetailList.get(idx).get("contractContents");
				individualContractVersion = (String)contractDetailList.get(idx).get("contractVersion");
				individualContractClassify = (String)contractDetailList.get(idx).get("contractClassify");
			}else{
				specialContractContents = (String)contractDetailList.get(idx).get("contractContents");
				specialContractVersion = (String)contractDetailList.get(idx).get("contractVersion");
				specialContractClassify = (String)contractDetailList.get(idx).get("contractClassify");
			}
		}
	}
	if(loginUserDto.getSmpVendorsDto() != null){
		businessNum = CommonUtils.getString(loginUserDto.getSmpVendorsDto().getBusinessNum());
	}else if(loginUserDto.getSmpBranchsDto() != null){
		businessNum = CommonUtils.getString(loginUserDto.getSmpBranchsDto().getBusinessNum());
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<%if(result == false){%>
<script type="text/javascript">
	alert("계약서 내용이 없습니다. \n관리자에게 문의하십시오.");
	location.href= "systemDefault.sys";
</script>
<%}%>
<title>OK Plaza에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<style type="text/css">
.jqmShapMail{
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 515px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .jqmAuthBusinessWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>

<!-- 그리드 이벤트 스크립트 -->

<%if(Constances.COMMON_ISREAL_SERVER){ %>
	<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<%} %>
<script type="text/javascript">
function fnAuth(){
	fnCommodityContractChk();
}


function fnMainPageTransfer() {
	parent.location.href='/system/systemHome.sys';
	
	
	
// 	var frm = document.frm;
// 	frm.action = "/system/systemDefault.sys";
// 	frm.submit();
}
$(document).ready(function(){
	$("#srcButton").click(function () { fnAuth();});
	$("#sharpMailDiv").jqmHide();
	$("#sharpMailDiv").jqm();//Dialog 초기화
	$("#btnSharpMailCloseDiv").click(function(){	//Dialog 닫기
		alert("모든 계약서명 절차가 취소되었습니다. \n다시 진행해 주시기 바랍니다");
		$("#sharpMailDiv").jqmHide();
		$("#sharpMailDiv").jqm();
	});
	
	$("#sharpMailDivClose").click(function(){	//Dialog 닫기
		alert("모든 계약서명 절차가 취소되었습니다. \n다시 진행해 주시기 바랍니다");
		$("#sharpMailDiv").jqmHide();
		$("#sharpMailDiv").jqm();
	});
	
	$("#btnSharpMailRegDiv").click(function(){
		sharpMailSave();
	});
	
	$("#sharpMailAddress").keydown(function(e){
		if(e.keyCode == 13){
			sharpMailSave();
		}
	});
// 	customResponse();
});

/**
 * 물품공급계약서 화면 보이기
 */
var contractVersionArray = new Array();
var contractClassifyArray = new Array();
function fnCommodityContractChk() {	
	var basicContractVersion = "<%=basicContractVersion%>";
	var basicContractClassify = "<%=basicContractClassify%>";
	
	var individualContractVersion = "<%=individualContractVersion%>";
	var individualContractClassify = "<%=individualContractClassify%>";
	
	var specialContractVersion = "<%=specialContractVersion%>";
	var specialContractClassify = "<%=specialContractClassify%>";
	if("" != basicContractVersion && "" != individualContractVersion){
		if($("input:radio[name=basicChk]:checked").val() == "1" && $("input:radio[name=individualChk]:checked").val() == "1"){
			contractVersionArray = [basicContractVersion,individualContractVersion];
			contractClassifyArray = [basicContractClassify,individualContractClassify];
			fnCommodityContractListValidation();//계약등록여부를 확인
		}else{
			alert("동의 합니다를 체크해 주세요.");
		}
	}else if("" != specialContractVersion){
		if($("input:radio[name=specialChk]:checked").val() == "1"){
			contractVersionArray = [specialContractVersion];
			contractClassifyArray = [specialContractClassify];
			fnCommodityContractListValidation();//계약등록여부를 확인
		}else{
			alert("동의 합니다를 체크해 주세요.");
		}
	}
}


/**
 * 물품공급계약서 서명중복 체크
 */

 function fnCommodityContractListValidation(){
	$.post(
		"/system/commodityContractListValidation.sys",
		{
			contractVersionArray:contractVersionArray,
			contractClassifyArray:contractClassifyArray
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse; 
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i];
				}
				alert(errors);
				document.cookie = "<%=contractCookie%>";
				fnMainPageTransfer();//메이페이지 이동
			}else{
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
			<%if(Constances.COMMON_ISREAL_SERVER){ %>
				$("#businessNum").val("");
				$("#popup_titlebar_bullet").attr("src","/img/homepage/red_titlebar_bullet.gif");
				$("#popup_titlebar_mid").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_mid.gif)');
				$("#popup_titlebar_left").attr("src","/img/homepage/red_titlebar_left.gif");
				$("#popup_titlebar_right").css("background-image",'url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/red_titlebar_right.gif)');
				$("#divTitleName").attr("color", "white");
				$("#btnAuthRegDiv").attr("src","/img/homepage/popup_btn_reg.gif");
				$("#btnAuthManageCloseDiv").attr("src","/img/homepage/popup_btn_cancel.gif");
				<%if("BUY".equals(loginUserDto.getSvcTypeCd())){ %>
<%-- 					fnAuthBusinessNumberDialog("CLT", "ETC", '1', "<%=businessNum%>", "sharpMailRegCheck", ""); --%>//샵메일부분 임시삭제
						fnAuthBusinessNumberDialog("CLT", "ETC", '1', "<%=businessNum%>", "fnContractAgreement", "");
				<%}else if("VEN".equals(loginUserDto.getSvcTypeCd())){%>
<%-- 					fnAuthBusinessNumberDialog("VEN", "ETC", '1', "<%=businessNum%>", "sharpMailRegCheck", ""); --%>
						fnAuthBusinessNumberDialog("VEN", "ETC", '1', "<%=businessNum%>", "fnContractAgreement", "");
				<%}%>
			<%}else{%>
				fnContractAgreement();
			<%}%>
			}
		}
	);
}

/**
 * 물품공급계약서 승인 펑션
 */
function fnContractAgreement() {
	$.post(
		"/system/commodityContractSave.sys",
		{
			contractVersionArray:contractVersionArray,
			contractClassifyArray:contractClassifyArray
		},
		function(arg){
			var result = eval('(' + arg + ')').customResponse; 
			var errors = "";
			if (result.success == false) {
				for (var i = 0; i < result.message.length; i++) {
					errors +=  result.message[i];
				}
				alert(errors);
				document.cookie = "<%=contractCookie%>";
				fnMainPageTransfer();//메인페이지 이동
			}else{
				alert("처리 하였습니다.");
				document.cookie = "<%=contractCookie%>";
				fnMainPageTransfer();//메인페이지 이동
			}
		}
	);	
}


//샵메일이 등록되어 있는지 체크
function sharpMailRegCheck(){
	$("#sharpMailAddress").val("");
	var borgId = "";
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())){%>
		borgId = "<%=loginUserDto.getSmpVendorsDto().getVendorId()%>";
<%	}else if("BUY".equals(loginUserDto.getSvcTypeCd())){%>
		borgId = "<%=loginUserDto.getSmpBranchsDto().getBranchId()%>";
<%	}	%>
	$.post(
		"/organ/sharpMailRegCheck.sys",
		{
			borgId:borgId,
			svcTypeCd:"<%=loginUserDto.getSvcTypeCd()%>"
		},
		function(arg){
			//count가 1이면 샵메일 등록절차 실행
			var result = eval("("+arg+")").count;
			if(result > 0){
				$("#sharpMailDiv").jqmShow();
			}else{
				fnContractAgreement();
			}
		}
	);

}


/**
 * 샵메일 등록절차
 */
function sharpMailSave(){
// 	var validation = sharpMailValidation();//샵메일 유효성 검사 제거
	var validation = true;
<%	if("VEN".equals(loginUserDto.getSvcTypeCd())){%>
	borgId = "<%=loginUserDto.getSmpVendorsDto().getVendorId()%>";
<%	}else if("BUY".equals(loginUserDto.getSvcTypeCd())){%>
	borgId = "<%=loginUserDto.getSmpBranchsDto().getBranchId()%>";
<%	}	%>
	if(validation){
		$.post(
			"/organ/sharpMailSave.sys",
			{
				borgId:borgId,
				svcTypeCd:"<%=loginUserDto.getSvcTypeCd()%>",
				sharpMailAddress:$("#sharpMailAddress").val()
			},
			function(arg){
				var result = eval("("+arg+")").customResponse.success;
				if(result == false){
					for (var i = 0; i < result.message.length; i++) {
						errors +=  result.message[i];
					}
					alert(errors);
				}else{
					fnContractAgreement();
				}
			}
		);
	}
}

/**
 * 샵메일 유효성 검사
 */
function sharpMailValidation(){
	var sharpMailAddress = $("#sharpMailAddress").val();
	if(sharpMailAddress == ""){
		alert("SHARP-MAIL을 입력해주세요.");  
		return false;
	}else{
		sharpMail_regex = /^[가-힣._-]+#[()가-힣._-]+\.[가-힣._-]{1,20}$/i;
		if(!sharpMail_regex.test(sharpMailAddress)){
			alert("SHARP-MAIL 유형을 확인해주세요.");
 			return false; 
		}
	}
	return true;
}


</script>


</head>
<body style="padding-left: 20px;">
<form id="frm" name="frm" method="post">
	<table width="977px" border="0" align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
			<!-- 메인 컨텐츠 시작-->
				<table width="977" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="757" valign="top">
						<!-- 메인 컨텐츠 내용 시작-->
							<table width="757px" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contract_title.gif" width="300" height="38" /></td>
									<td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11" /> Home &gt;<span class="orange">계약서</span></td>
								</tr>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
<%if(!"".equals(basicContractContents)){ %>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/b_contract.gif" width="757" height="48" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td width='100%' class='pcontent' colspan="2" align="left">
										<div style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:730px; height:240px;; padding:10px 10px 10px 10px;" >
											<%=basicContractContents %>
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
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/i_contract.gif" width="757" height="48" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								
								<tr>
									<td width='100%' class='pcontent' colspan="2" align="left">
										<div style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:730px; height:240px;; padding:10px 10px 10px 10px;" >
											<%=individualContractContents %>
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
<%}else{ %>
								<tr>
									<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/s_contract.gif" width="757" height="48" /></td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td width='100%' class='pcontent' colspan="2" align="left">
										<div style="height:100%; overflow:auto; border: solid 1px #e1e1e1; background-color:#ffffff; width:730px; height:450px;; padding:10px 10px 10px 10px;" >
											<%=specialContractContents %>
										</div>
									</td>
								</tr>
								<tr>
									<td colspan="2" align="left">
										<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" >
											<tr>
												<td align="center">
													<input type="radio" id="specialChk" name="specialChk" value="1" class="input_none" />
														동의합니다.
												</td>
												<td align="center">
													<input type="radio" id="specialChk" name="specialChk" value="2" class="input_none" />
														동의하지 않습니다.
												</td>
											</tr>
										</table>
									</td>
								</tr>
<%} %>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2" align="center" >
										<a href="#">
											<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_next.gif" border="0"/>
										</a>
									</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2">&nbsp;</td>
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
	</table>
</form>
<form id="frm2" name="frm2" method="post" target="parentFrame" action="">
</form>
<div id="sharpMailDiv" class="jqmShapMail">
	<table width="515"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="popup_titlebar_mid" style="background-image: url('/img/homepage/red_titlebar_mid.gif');">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="21"><img id="popup_titlebar_left" name="popup_titlebar_left" src="/img/homepage/red_titlebar_left.gif" width="21" height="47"/></td>
							<td width="22"><img id="popup_titlebar_bullet" name="popup_titlebar_bullet" src="/img/homepage/red_titlebar_bullet.gif" width="14" height="13" style="margin-bottom:5px; "/></td>
							<td class="popup_title"><font id="divTitleName" color="white">샵메일 등록</font></td>
		        			<td width="22" align="right">
		        				<img id="sharpMailDivClose" name="sharpMailDivClose" src="/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom:5px;cursor:pointer " />
		        			</td>
							<td id="popup_titlebar_right" width="10" style="background-image: url('/img/homepage/red_titlebar_right.gif');">&nbsp;</td>
						</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="/img/system/box_corner_2.gif" width="20" height="20"/></td>
					</tr>
					<tr>
						<td style="background-image: url('/img/system/box_line_4.gif');">&nbsp;</td>
						<td valign="top" bgcolor="#FFFFFF">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td class="table_td_subject" width="100">샵메일 주소</td>
									<td class="table_td_contents">
										<input id="sharpMailAddress" name="sharpMailAddress" type="text" size="30" />
										<input id="src" name="src" type="hidden" value="paj6PGYuEIKpGSYhgFYvDNnSmgw="/>
										<input id="signed_data" name="signed_data" type="hidden"/>
										<input id="userDn" name="userDn" type="hidden"/>
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="100">샵메일 회원가입</td>
									<td>
										<input type="button" id="sharpMailButton" name="sharpMailButton" value="회원가입" onclick="window.open('https://www.docusharp.com/member/join.jsp')" />
									</td>
								</tr>
								<tr>
									<td colspan="2" height='1' bgcolor="eaeaea"></td>
								</tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="2" height="5"></td>
								</tr>
							</table>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<a href="#">
										<img  id="btnSharpMailRegDiv" src="/img/homepage/popup_btn_reg.gif" style='border:0;'/>
										</a>
										<a href="#">
										<img id="btnSharpMailCloseDiv" src="/img/homepage/popup_btn_cancel.gif" style='border:0;'/>
										</a>
									</td>
								</tr>
							</table>
							<img src="/img/system/blank.gif" width='100%' height="10" class="space"/>
						</td>
						<td style="background-image: url('/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td><img src="/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('/img/system/box_line_3.gif');">&nbsp;</td>
						<td height="20"><img src="/img/system/box_corner_3.gif" width="20" height="20"/></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>

</body>
</html>