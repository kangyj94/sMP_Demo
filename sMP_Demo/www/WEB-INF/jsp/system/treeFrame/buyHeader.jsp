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
	boolean isBuyClt = false; // 법인 담당자 권한인지 확인  
	
	for(int i = 0; i < loginUserDto.getLoginRoleList().size(); i++){ //매니저권한관련 상호명 킻 조직이동명 변경
		String roleCd = loginUserDto.getLoginRoleList().get(i).getRoleCd();
		if( roleCd.equals("BUY_CLT") ){ isBuyClt = true; }
	}
%>

<style type="text/css">
.typeahead,
.tt-query,
.tt-hint {
  width: 300px;
  height: 16px;
  padding: 1px 1px;
  line-height: 15px;
/*   border: 1px solid #ccc; */
  outline: none;
}

.typeahead {
  background-color: #fff;
}

.typeahead:focus {
  border: 1px solid #0097cf;
}

.tt-query {
  -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
     -moz-box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
          box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.075);
}

.tt-hint {
  color: #999
}

.tt-menu {
  background-color: #fff;
  border: 1px solid #ccc;
  border: 1px solid rgba(0, 0, 0, 0.2);
  height:400px;
  width:250px;
}

.tt-suggestion {
  padding: 3px 20px;
  line-height: 24px;
}

.tt-suggestion:hover {
  cursor: pointer;
  color: #fff;
  background-color: #0097cf;
}

.tt-suggestion.tt-cursor {
  color: #fff;
  background-color: #0097cf;

}

.tt-suggestion p {
  margin: 0;
}

.belongBorgIdSvcTypeCd {color : #ea0001;}
option:not(:checked) { color : black;}
</style>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/typehead.js" type="text/javascript"></script>
<script>
$(document).ready(function() {
	var rtnStr = new Bloodhound({
// 		datumTokenizer: Bloodhound.tokenizers.whitespace,
// 		queryTokenizer: Bloodhound.tokenizers.whitespace,
// 		datumTokenizer:Bloodhound.tokenizers.obj.whitespace('Text'),
		datumTokenizer: function (datum) {
			alert(datum.value);
			return Bloodhound.tokenizers.whitespace(datum.value);
		},
		queryTokenizer:Bloodhound.tokenizers.whitespace,
		remote: {
			url		: '/buyProduct/pdtAutoComplete.sys?srcProductInput=%param',
			wildcard: '%param',
			filter  : function(response) {
				return response.resultList; 
			}
		}
	});

	$('.typeahead').typeahead({
	  	hint: true,
	  	highlight: true,
	  	minLength: 1
	}, {
	  	name: 'rtnStr',
	  	source: rtnStr,
	  	limit: 100
	});
	
	// 상품 검색 입력란 키 이벤트
	$("#srcProductInput").keydown(function(e){
		if(e.keyCode == 13){
			fnTotSearch(); //상품 검색 요청하는 메소드
			return false; //IE9 장바구니 페이지에서 fnTotSearch() 함수를 통해서 Submit()될때 견적서[fnOrderSheet()] 함수가 같이 실행되는 오류가 있어서 추가
		}
	}).css('vertical-align', 'middle');// label position
	
	$("#header_msnPop").on("click",function(e){
		window.open("/webChat/moveWebChatPop.sys", "webChat", "width=320,height=475,scrollbars=no,resizable=yes");
	});
	
	$("#belongBorgIdSvcTypeCd").change(function(e){
		fnLogin();
	});
	//chat 관련
<%	if(Constances.CHAT_ISUSE) {	%>
	setInterval(fnChatContinue,1000*<%=Constances.CHAT_LOGIN_SECOND %>);	//10초마다 한번씩 채팅 로그인(만약 시간을 고치면 체팅 로그아웃 스케줄러의 시간도 수정해야 함)
<%	}	%>
});
//상품 검색 요청하는 메소드
function fnTotSearch(){
	var srcProductInput       = $('#srcProductInput').val();
	var srcProductInputLength = 0; 
	
	srcProductInput       = $.trim(srcProductInput);
	srcProductInputLength = srcProductInput.length;
	
    if(srcProductInputLength == 0){
    	fnDynamicForm("/buyProduct/productResultList.sys", "", "");
    }
    else{
    	fnDynamicForm("/buyProduct/productResultList.sys", "inputWord=" + srcProductInput,"");
    }
}

function fnUserDetail(){
	var param = "borgId=<%=loginUserDto.getBorgId()%>&userId=<%=loginUserDto.getUserId() %>";	
	
    window.open("", 'organUserDetail', 'width=600, height=650, scrollbars=yes, status=no, resizable=yes');
	
    fnDynamicForm("/buyOrgan/organUserDetailBuy.sys", param, 'organUserDetail');
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
	
	window.open("", chatTarget, "width=322,height=400,scrollbars=no,resizable=yes");
	document.body.insertBefore(chatFrm, null);
	chatFrm.submit();
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

function fnBuyCartInfo(){
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyCart/buyCartInfo.sys", "_menuCd=BUY_ORDER_CART", '_self');
}

function fnGetBuyUserGoodList(){
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyProduct/getBuyUserGoodList.sys", "_menuCd=BUY_MY_INTER", '_self');
}

function fnAdmUserInfo(){
	var popurl = "/system/treeFrame/admUserInfo.home";
   	window.open(popurl, 'okplazaPop', 'width=810, height=550, scrollbars=yes, status=no, resizable=yes');	
}

//고객사 주문 취소 미승인
function fnBuyOrderCancel(){
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/menu/order/delivery/deliListBuy.sys", "_menuCd=BUY_ORDER_DELIVERY&linkOper=quick", '_self');
}

//고객사 반품 요청 미승인
function fnBuyReturnRequest(){
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/returnOrderRegist.sys", "_menuCd=BUY_RECEIVE_INFO&linkOper=quick", '_self');
}

//고객사 주문 승인
function fnBuyApprovalRequest(){
	fnDynamicForm("<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/approvalOrderListBuy.sys", "_menuCd=BUY_ORDE_APPROVAL", '_self');
}
</script>
<%--header start! --%>
<div id="header">
	<h1 style="margin-top:-20px;">
		<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys">
			<img src="/img/layout/logo.gif" width="170" />
		</a>
	</h1>
	<div id="divCommon1" class="selectbox">
		<ul>
			<li>
				<a href="#">
					<img id="admUserInfo" name="admUserInfo" src="/img/homepage/adm_user_info.png" border="0" onclick="javaScript:fnAdmUserInfo();" height="16px"/>
				</a>
			</li>
<!-- 			<li> -->
<%-- 				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys"> --%>
<!-- 					<i class="fa fa-home" style="color: #DF0223;"></i> HOME -->
<!-- 				</a> -->
<!-- 			</li> -->
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemLogout.sys">
					<i class="fa fa-power-off" style="color: #DF0223;"></i> 로그아웃
				</a>
			</li>
<!-- 			<li> -->
<!-- 				<a href="javascript:fnBuyCartInfo();" > -->
<!-- 					<i class="fa fa-shopping-cart" style="color: #DF0223;"></i> 장바구니 -->
<!-- 				</a> -->
<!-- 			</li> -->
<!-- 			<li> -->
<!-- 				<a href="javascript:fnGetBuyUserGoodList();" > -->
<!-- 					<i class="fa fa-star" style="color: #DF0223;"></i> 관심상품 -->
<!-- 				</a> -->
<!-- 			</li> -->
<%-- <%	if( isBuyClt ){//법인담당자 %> --%>
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrgan/organBuyList.sys?_menuCd=BUY_MY_BORG">
					<i class="fa fa-cubes" style="color: #DF0223;"></i> 사업장관리
				</a>
			</li>
			<li>
				<a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrgan/organBuyUserList.sys?_menuCd=BUY_MY_USER">
					<i class="fa fa-users" style="color: #DF0223;"></i> 사용자관리
				</a>
			</li>
<%-- <%	} %> --%>
			<li>
				<a id="header_msnPop" name="header_msnPop" href="javascript:void(0);">
					<i class="fa fa-weixin" style="color: #DF0223;"></i> 채팅
				</a>
			</li>
			<li>
				<a href="javascript:fnUserDetail();">
					<i class="fa fa-user" style="color: #DF0223;"></i> <strong style="height:26px;margin-right:5px;"><%=loginUserDto.getUserNm() %></strong>
				</a>
			</li>
<%	if(belongBorgList.size() > 1) {	//소속조직이 1개이상일 경우 변경가능 %>
			<li id="">
<%
		String selectString          = null;
		String belongBorgId          = null;
		String belongBorgSvcTypeCd   = null;
		String belongBorgAdminUserId = null;
		String belongBorgNm          = null;
%>
				<select id="belongBorgIdSvcTypeCd" name="belongBorgIdSvcTypeCd" class="belongBorgIdSvcTypeCd" style="height: 24px;">
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
	
	<div id="search" style="margin-top:4px;">
		<span class="col02">상품검색</span>
		<input id="srcProductInput" name="srcProductInput" class="typeahead" type="text" placeholder="검색어를 입력하세요"  />
        <a href="javascript:fnTotSearch();">
        	<img src="/img/layout/btn_search.gif" class="middle" />
        </a>
	</div>
	<div id="divGnb">
		<h2 class="Dn">대메뉴</h2>
		<ul class="gnb">
			<li class="gnbMenu01">
				<span>주문</span>
			</li>
			<li class="gnbMenu02">
				<span>인수/반품</span>
			</li>
			<li class="gnbMenu03">
				<span>정산</span>
			</li>
			<li class="gnbMenu04">
				<span>상품제안</span>
			</li>
			<li class="gnbMenu05">
				<span>고객센터</span>
			</li>
		</ul>
	</div>
<%--서브메뉴 start! --%>
<div id="snb" >
  <div id="submenu">
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
<%    } %>
<%    if("BUY_ORDER".equals(bigMenuDto.getMenuCd()) && loginUserDto.isDirectMan() ){//감독관 %>
      <li>
        <a href="<%=Constances.SYSTEM_CONTEXT_PATH %>/buyOrder/approvalOrderListBuy.sys?_menuCd=BUY_ORDE_APPROVAL">주문승인</a>
      </li>
<%    } %>
    </ul>
<%
  }
%>        
  </div>
</div>
</div>
<%--서브메뉴 end! --%>
<%--header end! --%>