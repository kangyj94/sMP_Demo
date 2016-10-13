<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginMenuDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.BorgDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%
	LoginUserDto       loginUserDto   = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	List<BorgDto>      belongBorgList = loginUserDto.getBelongBorgList();	//소속조직리스트
	List<LoginMenuDto> bigMenuList    = loginUserDto.getBigMenuList();
%>
<script type="text/javascript">
//<!--
$(document).ready(function() {
	$("#header_msnPop").on("click",function(e){
		window.open("/webChat/moveWebChatPop.sys", "webChat", "width=320,height=475,scrollbars=no,resizable=yes");
	});	
	
	$("#belongBorgIdSvcTypeCd").change(function(e){
		fnLogin();
	});
<%
	if(Constances.CHAT_ISUSE) {
%>
	setInterval(fnChatContinue, 1000*<%=Constances.CHAT_LOGIN_SECOND %>);	//10초마다 한번씩 채팅 로그인(만약 시간을 고치면 체팅 로그아웃 스케줄러의 시간도 수정해야 함)
<%
	}
%>
});

function fnUserDetail(){
	var param = "_menuCd=VEN_MY_USER&borgId=<%=loginUserDto.getBorgId()%>";
	
	param = param + "&userId=<%=loginUserDto.getUserId() %>";
	
    window.open("", 'organUserDetail', 'width=600, height=415, scrollbars=yes, status=no, resizable=yes');
    
    fnDynamicForm("/organ/selectVendorUserDetail.sys", param, 'organUserDetail');
}

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
	var chatFrm    = document.createElement("form");
	
	chatFrm.name   = "chatForm";
	chatFrm.method = "post";
	chatFrm.action = "<%=Constances.SYSTEM_CONTEXT_PATH %>/webChat/talkWebChatPop.sys";
	chatFrm.target = chatTarget;
	
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
	
	window.open("", chatTarget, "width=322,height=450,scrollbars=no,resizable=yes");
	
	document.body.insertBefore(chatFrm, null);
	
	chatFrm.submit();
}

function fnVendorDetail(){
	var param = "_menuCd=VEN_MY_ORG&vendorId=<%=loginUserDto.getBorgId()%>";
	
    window.open("", 'vendorDetail', 'width=920, height=670, scrollbars=yes, status=no, resizable=yes');
    
    fnDynamicForm("/organ/organVendorDetail.sys", param, 'vendorDetail');
}

function fnLogin() {
	var belongBorgId    = $("#belongBorgIdSvcTypeCd").val().split("∥")[0];
	var belongSvcTypeCd = $("#belongBorgIdSvcTypeCd").val().split("∥")[1];
	var moveUserId      = $("#belongBorgIdSvcTypeCd").val().split("∥")[2];
	var param           = "belongBorgId=" + belongBorgId;
	
	param = param + "&belongSvcTypeCd=" + belongSvcTypeCd;
	param = param + "&moveUserId=" + moveUserId;
	
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/system/belongSystemLogin.sys", param, '_parent');
}

function fnAdmUserInfo(){
	var popurl = "/system/treeFrame/admUserInfo.home";
   	window.open(popurl, 'okplazaPop', 'width=810, height=550, scrollbars=yes, status=no, resizable=yes');	
}
//-->
</script>
<%--header start! --%>
<div id="header_vdr">
	<h1>
		<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys">
			<img src="/img/layout/logo.gif" width="170" />
		</a>
	</h1>
	<div id="divCommon1">
		<ul>
			<li>
				<a href="#">
					<img id="admUserInfo" name="admUserInfo" src="/img/homepage/adm_user_info.png" border="0" onclick="javaScript:fnAdmUserInfo();" height="16px"/>
				</a>
			</li>
<!-- 			<li> -->
<%-- 				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/order/delivery/deliCompleteList.sys"><i class="fa fa-truck" style="color: #DF0223;"></i> (임시)배송입력</a> --%>
<!-- 			</li> -->
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys"><i class="fa fa-home" style="color: #DF0223;"></i> HOME</a>
			</li>
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemLogout.sys"><i class="fa fa-power-off" style="color: #DF0223;"></i> 로그아웃</a>
			</li>
			<li onclick="javascript:fnUserDetail();" style="cursor: pointer;">
				<i class="fa fa-user" style="color: #DF0223;"></i> <strong style="margin-right:5px;"><%=loginUserDto.getUserNm() %></strong>
			</li>
			<li>
				<a href="javascript:fnVendorDetail();"><i class="fa fa-cubes" style="color: #DF0223;"></i> <%=loginUserDto.getBorgNm() %></a>
			</li>
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/venOrgan/organVenUserList.sys?_menuCd=VEN_ETC_USER">
					<i class="fa fa-users" style="color: #DF0223;"></i>사용자관리
				</a>
			</li>
			<li>
				<a id="header_msnPop" href="javascript:void(0);"><i class="fa fa-weixin" style="color: #DF0223;"></i> 채팅</a>
			</li>
<%	if(belongBorgList.size() > 1) {	//소속조직이 1개이상일 경우 변경가능 %>
			<li>
<%
		String selectString          = null;
		String belongBorgId          = null;
		String belongBorgSvcTypeCd   = null;
		String belongBorgAdminUserId = null;
		String belongBorgNm          = null;
%>
				<select id="belongBorgIdSvcTypeCd" name="belongBorgIdSvcTypeCd" style="height: 26px;">
<%
		for(BorgDto belongBorgDto:belongBorgList) {
			selectString          = (belongBorgDto.getBorgId()).equals(loginUserDto.getBorgId()) ? "selected" : "";
			belongBorgId          = belongBorgDto.getBorgId();
			belongBorgSvcTypeCd   = belongBorgDto.getSvcTypeCd();
			belongBorgAdminUserId = CommonUtils.getString(belongBorgDto.getAdminUserId());
			belongBorgNm          = belongBorgDto.getBorgNm();
%>
					<option value="<%=belongBorgId %>∥<%=belongBorgSvcTypeCd %>∥<%=belongBorgAdminUserId %>" <%=selectString %>><%=belongBorgNm %></option>
<%		}	%>
				</select>
			</li>
<%	}	%>
		</ul>
	</div>
	<div id="divGnb">
		<h2 class="Dn">대메뉴</h2>
		<ul class="gnb">
			<li class="gnbMenu1">
				<span>주문/배송관리</span>
			</li>
			<li class="gnbMenu2">
				<span>인수/반품</span>
			</li>
			<li class="gnbMenu3">
				<span>정산</span>
			</li>
			<li class="gnbMenu4">
				<span>상품</span>
			</li>
			<li class="gnbMenu5">
				<span>고객센터</span>
			</li>
		</ul>
	</div>

<%--서브메뉴 start! --%>
<div id="snb_vdr">
  <div id="submenu_vdr">
<%
  for(LoginMenuDto bigMenuDto : bigMenuList) {
    List<LoginMenuDto> subMiddleMenuList    = bigMenuDto.getSubMenuList();
    String             middleMenuFwdPath    = null;
    String             middleMenuId         = null;
    String             middleMenuHref       = null;
    StringBuffer       middleMenuHrefBuffer = null;
%>
    <ul>
<%
    for(LoginMenuDto middleMenuDto : subMiddleMenuList) {
      middleMenuFwdPath    = middleMenuDto.getFwdPath();
      middleMenuId         = middleMenuDto.getMenuId();
      middleMenuHrefBuffer = new StringBuffer();
      
      middleMenuHrefBuffer.append(Constances.SYSTEM_CONTEXT_PATH).append(middleMenuFwdPath).append("?_menuId=").append(middleMenuId);
      
      middleMenuHref = middleMenuHrefBuffer.toString();
%>
      <li>
        <a href="<%=middleMenuHref %>"><%=middleMenuDto.getMenuNm() %></a>
      </li>
<%
    }
%>
    </ul>
<%
  }
%>
    </div>
  </div>
  <!--//서브메뉴 -->
</div>
	<!--//header-->