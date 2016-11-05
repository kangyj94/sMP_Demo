<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginMenuDto" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<LoginMenuDto> staticMenuList = loginUserDto.getStaticMenuList();	//고정메뉴리스트
	List<BorgDto> belongBorgList = loginUserDto.getBelongBorgList();	//소속조직리스트
	boolean manageFlag = true;//true면 SMS팝업 나오게
	
	//매니저권한관련 상호명 킻 조직이동명 변경
	for(int i=0; i<loginUserDto.getLoginRoleList().size(); i++){
		String roleCd = loginUserDto.getLoginRoleList().get(i).getRoleCd();
		if(roleCd.equals(Constances.ETC_SPECIAL_SKB)){
			loginUserDto.setBorgNm("SKB");
			for(int j=0; j<belongBorgList.size(); j++){
				if("13".equals(belongBorgList.get(j).getBorgId())){
					belongBorgList.get(j).setBorgNm("에스케이브로드밴드");
				}
			}
			manageFlag = false;//매니저권한의 경우 SMS팝업 나오지 않게 처리
		}else if(roleCd.equals(Constances.ETC_SPECIAL_SKT)){
			loginUserDto.setBorgNm("SKT");
			for(int j=0; j<belongBorgList.size(); j++){
				if("13".equals(belongBorgList.get(j).getBorgId())){
					belongBorgList.get(j).setBorgNm("에스케이텔레콤");
				}
			}
			manageFlag = false;//매니저권한의 경우 SMS팝업 나오지 않게 처리
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/redmond/jquery-ui-1.8.2.custom.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/themes/ui.jqgrid.css" rel="stylesheet" type="text/css" media="screen" />
<link href="<%=Constances.SYSTEM_JSCSS_URL %>/css/hmro_green_tree.css" rel=StyleSheet />
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jqgrid.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>

<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/webChat.js" type="text/javascript"></script><%//웹챗 활성화를 위해 js 파일 추가(2013.02.06, tytolee) %>
<style type="text/css">
/*
	body {
		background:#ffffff;
		background-repeat:repeat-x;
 		margin-top:5px;
		margin-left:7px;
		margin-right:0px;
 		width: 1280px;
	}
*/
</style>

<script type="text/javascript">
<%
/**
 * 채팅 이미지 클릭시 채팅 팝업창을 호출하는 메소드
 *
 * @author : tytolee
 * @since : 2012-06-04
 */
%>

function fnAdmUserInfo(){
	var popurl = "/system/treeFrame/admUserInfo.home";
   	window.open(popurl, 'okplazaPop', 'width=810, height=650, scrollbars=yes, status=no, resizable=yes');	
}

/**
 * 채팅관련 함수 
 */
//채팅사용자 조회 팝업
function msnbgOnClick(){
	window.open("<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/moveWebChatPop.sys", "webChat", "width=300,height=400,scrollbars=no,resizable=yes");
}

$(document).ready(function() {
	$('#loginDialogPop').jqm();	//loginDialog 초기화
	$("#belongBorgIdSvcTypeCd").change(function(e){
		fnLogin();
	});
<%	if(Constances.CHAT_ISUSE) {	%>
	$("#staticMenu2").show();
	setInterval(fnChatContinue,1000*<%=Constances.CHAT_LOGIN_SECOND %>);	//10초마다 한번씩 채팅 로그인(만약 시간을 고치면 체팅 로그아웃 스케줄러의 시간도 수정해야 함)
<%	}	%>
});
//채팅사용자 연속성
function fnChatContinue() {
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/chatContinue.sys", 
		{},
		function(arg){
			var result = eval('(' + arg + ')').chatLoginDto;
			if(result != undefined){
				if(result.userId != '') {
					_getWebChatPop(result.userId, result.branchId, result.userNm);
				}
			}
		}
	);
}
//채팅창 호출
function _getWebChatPop(userId, branchId, userNm) {
	var chatTarget = userId+"_"+branchId;
	var chatFrm = document.createElement("form");
	chatFrm.name="chatForm";
	chatFrm.method="post";
	chatFrm.action="<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/talkWebChatPop.sys";
	chatFrm.target=chatTarget;
	
	var userIdObj = document.createElement("input");
	userIdObj.type = "hidden";
	userIdObj.name = "userId";
	userIdObj.value = userId;
	chatFrm.insertBefore(userIdObj, null);
	
	var branchIdObj = document.createElement("input");
	branchIdObj.type = "hidden";
	branchIdObj.name = "branchId";
	branchIdObj.value = branchId;
	chatFrm.insertBefore(branchIdObj, null);
	
	var userNmObj = document.createElement("input");
	userNmObj.type = "hidden";
	userNmObj.name = "userNm";
	userNmObj.value = userNm;
	chatFrm.insertBefore(userNmObj, null);
	
	window.open("", chatTarget, "width=300,height=400,scrollbars=no,resizable=yes");
	document.body.insertBefore(chatFrm, null);
	chatFrm.submit();
}

function fnLogin() {
	var belongBorgId = $("#belongBorgIdSvcTypeCd").val().split("∥")[0];
	var belongSvcTypeCd = $("#belongBorgIdSvcTypeCd").val().split("∥")[1];
	var moveUserId = $("#belongBorgIdSvcTypeCd").val().split("∥")[2];
	$("#belongBorgId").val(belongBorgId);
	$("#belongSvcTypeCd").val(belongSvcTypeCd);
	$("#moveUserId").val(moveUserId);
	frm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/system/belongSystemLogin.sys";
	frm.target = "_parent";
	frm.submit();
}
 
function existingSystemClick() {
	alert("기존 시스템에서는 주문 및 발주행위를 금합니다. \n실적조회만 가능합니다.");
	window.open("http://219.252.78.20/",target="_blank");
}

function smsTrnasAgentPopUp(){
  	var popurl = "/common/smsTransAgentPop.sys";
    window.open(popurl, 'okplazaSmsPop', 'width=970px, height=525px, scrollbars=no, status=no, resizable=yes');
}
</script>
</head>

<body>
<form id="frm" name="frm" method="post">
<input type="hidden" id="belongBorgId" name="belongBorgId"/>
<input type="hidden" id="belongSvcTypeCd" name="belongSvcTypeCd"/>
<input type="hidden" id="moveUserId" name="moveUserId"/>
<table width="100%" align="center">
	<tr>
		<td align="center">
			<table width="1280px" border="0" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td height="35">
						<div id="staticMenu3" onclick="javascript:parent.location.href='<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemHome.sys';">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/SkTeleSys_logo.jpg" style="height: 61px;cursor: pointer;"/>
						</div>
					</td>
					<td align="right">
						<table border="0" cellspacing="0" cellpadding="5">
							<tr>
								<td>
									<div class="r-row1-cell" style="top: 10px; margin-right: 20px;">
										<div style=" border-radius: 10px;  border: 1px solid #D5D5D5; width:100%; align:center; height:27px; line-height: 27px; padding-left: 7px; padding-right: 7px;">
											<select id="goFavoritesMenu" class="select"></select>
											<img id="addFavoritesMenu" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Add.gif" 
													width="15" height="15" style="border:0;display:inline;vertical-align: sub; margin-left: 5px;" title="즐겨찾기 메뉴추가">
											<img id="delFavoritesMenu" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Trash.gif" 
													width="15" height="15" style="border:0;display:inline;vertical-align: sub; margin-left: 5px;" title="즐겨찾기 메뉴삭제">
													
										</div>
									</div>
								</td>
<%if(manageFlag){%>
								<td>
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/existingSystemBtn.gif" style="cursor: pointer;" onclick="javascript:existingSystemClick();"/>
								</td>
<%} %>
								<td>
									<a href="#"><img id="admUserInfo" name="admUserInfo" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/adm_user_info.png" border="0" onclick="javaScript:fnAdmUserInfo();"/></a>
								</td>
<%if(loginUserDto.getSvcTypeCd().equals("ADM")){ %>
	<%if(manageFlag){%>
								<td>
									<a href="javascript:smsTrnasAgentPopUp();"> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/smsimg.png" border="0" style="cursor: pointer;" /></a>
								</td>
	<%} %>
<%} %>
								
<%	if(belongBorgList.size()>1) {	//소속조직이 1개이상일 경우 변경가능	%>
								<td class="table_td_subject1_1">
									조직이동 :
									<select class="select" id="belongBorgIdSvcTypeCd" name="belongBorgIdSvcTypeCd">
<%
		for(BorgDto belongBorgDto:belongBorgList) {
			String selectString = (belongBorgDto.getBorgId()).equals(loginUserDto.getBorgId()) ? "selected" : "";
%>
										<option value="<%=belongBorgDto.getBorgId() %>∥<%=belongBorgDto.getSvcTypeCd() %>∥<%=CommonUtils.getString(belongBorgDto.getAdminUserId()) %>" <%=selectString %>>
											<%=belongBorgDto.getBorgNm() %>
										</option>
<%		} %>
									</select>
								</td>
<%	} %>
								<td>
									<table  border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_left.gif" width="10" height="27"/></td>
											<td width="55" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_center.gif);" align="center">
												<b>사용자 :</b>
											</td>
											<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_center.gif);">
												<%=loginUserDto.getUserNm() %>
											</td>
											<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_center.gif);">
												&nbsp;
											</td>
											<td width="45" align="center" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_center.gif);">
												<b>상호 :</b>
											</td>
											<td style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_center.gif);">
											<%if(loginUserDto.isGuest()){ %>
												<%=loginUserDto.getBorgNms() %>
											<%}else{ %>
												<%=loginUserDto.getBorgNm() %>
											<%} %>
											</td>
											<td width="10"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/service_box_right.gif" width="10" height="27"/></td>
										</tr>
									</table>
								</td>
								<td>
									<div id="staticMenu2" onclick="javascript:msnbgOnClick();" style="display: none;">
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/User_group.gif" style="cursor: pointer;"/>
									</div>
								</td>
								<td>
									<div id="staticMenu3" onclick="javascript:parent.location.href='<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemHome.sys';">
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/global_home.gif" style="cursor: pointer;"/>
									</div>
								</td>
								<td>
									<div id="staticMenu4" onclick="javascript:parent.location.href='<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemLogout.sys';">
										<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/menu/global_logout.gif" style="cursor: pointer;"/>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				

			</table>
		</td>
	</tr>
</table>
<%@ include file="/loginCheckPup.jsp" %>
</form>
</body>

<%----------- 즐겨찾기 메뉴 관련  -----------%>
<script type="text/javascript">
$(document).ready(function() {
	setFavoritesMenu();
	
// 	$("#addFavoritesMenu, #delFavoritesMenu").tooltip();
	$("#addFavoritesMenu").click( addFavoritesMenu );
	$("#delFavoritesMenu").click( delFavoritesMenu);
	$("#goFavoritesMenu").on('change',function(){
		goFavoritesMenu();
	});
	
	
});

function addFavoritesMenu(){
	var menuId = window.parent.frames["frameMenu"].selMunuId;
	var menuNm = window.parent.frames["frameMenu"].selMunuNm;
	
	if( menuId ==  0 ){
		alert("home 메뉴는 즐겨찾기 할 수 없습니다.");
		return;
	}
	//validation check 
	var flag = $("#goFavoritesMenu option").is("[value="+menuId+"]");
	
	if( flag ){
		alert("["+menuNm+"] 메뉴는 \n이미 즐겨찾기에 등록된 메뉴입니다.");
		return;
	}
	if( confirm("["+menuNm+"] 메뉴를 즐겨찾기에 추가하시겠습니까?") == false ){return;}
	
	$.post(
			"/system/regfavoritesMenu.sys", 
			{
				menuId : menuId
			},
			function(arg){ 
				var result = eval('(' + arg + ')').customResponse;
				var errors = "";
				if (result.success == false) {
					for (var i = 0; i < result.message.length; i++) {
						errors +=  result.message[i] + "<br/>";
					}
					alert(errors);
					
				} else {
					alert("즐겨찾기에서 메뉴가 추가되었습니다.");					
					setFavoritesMenu();
				}
			}
		); 	
}

function delFavoritesMenu(){

	var menuId = window.parent.frames["frameMenu"].selMunuId;
	var menuNm = window.parent.frames["frameMenu"].selMunuNm;
	
	//validation check 
	var flag = $("#goFavoritesMenu option").is("[value="+menuId+"]");
	
	
	if( menuId=="0" || ! flag ){
		alert("즐겨찾기에 등록되지 않은 메뉴입니다.");
		return;
	}
	
	if( ! confirm("["+menuNm+"] 메뉴를 즐겨찾기에서 삭제 하시겠습니까?")){return;}

	$.post(
			"/system/delfavoritesMenu.sys", 
			{
				menuId : menuId
			},
			function(arg){ 
				var result = eval('(' + arg + ')').customResponse;
				var errors = "";
				if (result.success == false) {
					for (var i = 0; i < result.message.length; i++) {
						errors +=  result.message[i] + "<br/>";
					}
					alert(errors);
					
				} else {
					alert("즐겨찾기에서 메뉴가 삭제되었습니다.");					
					setFavoritesMenu();
				}
			}
		); 	
}

function goFavoritesMenu(){
	var menuId = $("#goFavoritesMenu").val();
	var menuNm = $("#goFavoritesMenu").find(":selected").text(); 
	if( menuId == 0 ){
		return;
	}
	
	window.parent.frames["frameMenu"].goMenu(menuId);
	window.parent.frames["frameMenu"].selMunuNm = menuNm;
	window.parent.frames["frameMenu"].selMunuId = menuId;
	
	$("#goFavoritesMenu").val("0");
}

function setFavoritesMenu(){
	//초기화
// 	$("#goFavoritesMenu").empty();
// 	$("#goFavoritesMenu").append("<option value='0'>즐겨찾기 메뉴</option>");
	
// 	$.post(
// 			"/system/getFavoritesMenu.sys", 
// 			{},
// 			function(arg){
// 				var list = $.parseJSON(arg).list;

// 				for(i=0 ; i < list.length ; i++){
// 					$("#goFavoritesMenu").append("<option value='"+list[i].menuId+"'>"+ list[i].menuNm+"</option>");
// 				}
// 			}
// 		); 	
}
</script>
<%----------- /즐겨찾기 메뉴 관련  -----------%>
</html>