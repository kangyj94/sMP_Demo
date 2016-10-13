<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginMenuDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>

<%
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean contract_flag = request.getAttribute("CONTRACT_FLAG")==null ? true : (Boolean)request.getAttribute("CONTRACT_FLAG");
	
	List<LoginMenuDto> bigMenuList = new ArrayList<LoginMenuDto>();
	if(contract_flag) {
		bigMenuList = loginUserDto.getBigMenuList();
	} 
	
	//매니저 권한으로 들어올 경우 모든 메뉴 오픈
	List<LoginRoleDto> roleList = (List<LoginRoleDto>)loginUserDto.getLoginRoleList();
	boolean menuOpenFlag = false;
	for(int i=0; i<roleList.size(); i++){
		String roleCd = roleList.get(i).getRoleCd();
		if("ADM_SPECIAL_SKT".equals(roleCd) || "ADM_SPECIAL_SKB".equals(roleCd) || "ADM_SPECIAL_CON".equals(roleCd)){
			menuOpenFlag = true;
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=Constances.SYSTEM_SERVICE_TITLE %></title>
<link rel="StyleSheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.css" type="text/css"/>
<link rel="StyleSheet" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/complex.css" type="text/css"/>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
<%-- <script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree.js"></script> --%>
<script type="text/javascript" src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/dtree/dtree-1.2.js"></script>
<style type="text/css">
.contract_td_contents{
	font-size:13px;
	font-family: 돋움;
	font:bold;
	color:#333333;	
	white-space:nowrap;
}
</style>
<script language="javascript">
$(document).ready(function() {
	var tmpHeight = $(window).height();
	<%if(!"ADM".equals(loginUserDto.getSvcTypeCd())){%>
		$("#leftDt").css("height",tmpHeight-250);
		$("#tab_0").css("height",tmpHeight-250);
	<%}else{%>
		$("#leftDt").css("height",tmpHeight-120);
		$("#tab_0").css("height",tmpHeight-120);
	<%}%>
	$("#srcMenuText").keydown(function(e){
		var tmpSrcText = $.trim($("#srcMenuText").val());
		if(e.keyCode==13 && tmpSrcText.length>0) {
			fnFindSearchText(tmpSrcText);
		} else if(e.keyCode==13 && tmpSrcText.length==0) {
			ct.closeAll();
		}
	});
	menuAllOpen();//매니저 권한으로 들어올 경우 모든 메뉴 오픈
});
$(window).bind('resize', function() { 
	var tmpHeight = $(window).height();
	<%if(!"ADM".equals(loginUserDto.getSvcTypeCd())){%>
		$("#leftDt").css("height",tmpHeight-250);
		$("#tab_0").css("height",tmpHeight-250);
	<%}else{%>
		$("#leftDt").css("height",tmpHeight-120);
		$("#tab_0").css("height",tmpHeight-120);
	<%}%>
}).trigger('resize');

var selMunuId = "0";
var selMunuNm = "HOME";

function goMenu(menuId){
	
	var sctId = $(".menu" + menuId ).attr("id");
	
	var menuNm = $(".menu" + menuId ).html();
	var href = $(".menu" + menuId ).attr("href");
	var id = sctId.replace("sct","");
	
	window.parent.frames["frameMain"].location.href = href;

	
}

function showHideLeftFrame() {
	var bodyFrmObj = parent.document.getElementById("bodyFrm");
	var cols = bodyFrmObj.cols.split(",");
	if (cols[0] == 23) {
		bodyFrmObj.cols = "250,*";
		$('#okplaza').slideToggle("slow");
		$("#leftDiv").slideToggle("slow");
		$("#contractDiv").slideToggle("slow");
	} else {
		bodyFrmObj.cols = "23, *";
		$('#okplaza').slideToggle("slow");
		$("#leftDiv").hide();
		$("#contractDiv").slideToggle("slow");
	}
}

function fnFindSearchText(schText) {
	var menuArray = new Array();
<%	
	int arrayCnt = 0;
	for(LoginMenuDto bigMenuDto : bigMenuList) {
		List<LoginMenuDto> subMiddleMenuList = bigMenuDto.getSubMenuList();
		boolean isLeafMiddle = subMiddleMenuList.size()>0 ? false : true;
		String subMiddleUrl = isLeafMiddle ? Constances.SYSTEM_CONTEXT_PATH + bigMenuDto.getFwdPath() + "?_menuId=" + bigMenuDto.getMenuId() : "";
%>
	menuArray[<%=arrayCnt%>] = new Array(2);
	menuArray[<%=arrayCnt%>][0] = "<%=bigMenuDto.getMenuId()%>";
	menuArray[<%=arrayCnt++%>][1] = "<%=isLeafMiddle ? bigMenuDto.getMenuNm() : ""%>";
<%
		for(LoginMenuDto middleMenuDto : subMiddleMenuList) {
			List<LoginMenuDto> subSmallMenuList = middleMenuDto.getSubMenuList();
			boolean isLeafSmall = subSmallMenuList.size()>0 ? false : true;
			String subSmallUrl = isLeafSmall ? Constances.SYSTEM_CONTEXT_PATH + middleMenuDto.getFwdPath() + "?_menuId=" + middleMenuDto.getMenuId() : "";
%>
	menuArray[<%=arrayCnt%>] = new Array(2);
	menuArray[<%=arrayCnt%>][0] = "<%=middleMenuDto.getMenuId()%>";
	menuArray[<%=arrayCnt++%>][1] = "<%=isLeafSmall ? middleMenuDto.getMenuNm() : ""%>";
<%
			for(LoginMenuDto smallMenuDto : subSmallMenuList) {
				boolean isLeafEtc = true;	//소메뉴 이하는 없는걸로 구성
				String subEtcUrl = isLeafEtc ? Constances.SYSTEM_CONTEXT_PATH + smallMenuDto.getFwdPath() + "?_menuId=" + smallMenuDto.getMenuId() : "";
%>
	menuArray[<%=arrayCnt%>] = new Array(2);
	menuArray[<%=arrayCnt%>][0] = "<%=smallMenuDto.getMenuId()%>";
	menuArray[<%=arrayCnt++%>][1] = "<%=isLeafEtc ? smallMenuDto.getMenuNm() : ""%>";
<%
			}
		}
	}
%>
	var firstChkCnt = 0;
	for(var i=0;i<menuArray.length;i++) {
		if(menuArray[i][1].indexOf(schText)>-1) {
			ct.openTo(menuArray[i][0],false,false);
			if(firstChkCnt++==0) {
				ct.s(i+1);
				parent.frameMain.location.href = $('#sct'+(i+1)).attr('href');
			}
		}
	}
}

function fnContractView(contractVersion) {
<%		if("BUY".equals(loginUserDto.getSvcTypeCd())){%>
			var popurl = "/system/systemContractPopup.sys?contractVersion="+contractVersion+"&contractClassify="+"<%=loginUserDto.getSvcTypeCd()%>"+"&contractSpecial="+"<%=loginUserDto.getSmpBranchsDto().getContractSpecial()%>";
<%		}else{ %>
			var popurl = "/system/systemContractPopup.sys?contractVersion="+contractVersion+"&contractClassify="+"<%=loginUserDto.getSvcTypeCd()%>";
<%		} %>
		window.open(popurl, 'okplazaPop', 'width=760, height=800, scrollbars=yes, status=no, resizable=no');
}

function smBbsList(){
 	$("#frm").submit();
}

//매니저 권한으로 들어올 경우 모든 메뉴 오픈
function menuAllOpen (){
	var menuOpenFlag = <%=menuOpenFlag%>;
	if(menuOpenFlag){
		ct.openAll();
	}
}

function vocPopView(){
	var popurl = "/voc/vocWrite.sys";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
	window.open(popurl, 'vocWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
}

function vocGo(){
<%if(!"ADM".equals(loginUserDto.getSvcTypeCd())){%>	
	var popurl = "/voc/vocWrite.sys";
	var popproperty = "dialogWidth:720px;dialogHeight=600px;scroll=auto;status=no;resizable=no;";
	window.open(popurl, 'vocWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
<%}else{%>
	$("#frm2").submit();
<%}%>
}
</script>
</head>

<body>
<!-- 각 메뉴의 내용 -->
<table id="main_table" width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="background-color: #F6F6FA;" >
	<tr>
		<td valign="bottom">
			<div class="tab_header">
				<div id="tabs" style="font-size: 0.85em;cursor: pointer;" onclick="javascript: showHideLeftFrame();">
					<span id='okplaza' style="vertical-align: bottom;">OK 플라자</span>
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/jq/js/dtree/Images/Left-right.gif" style="vertical-align: middle;height: 20px;" alt="숨기기/보이기" />
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td id="leftDt" style="padding:5 0 10 5;vertical-align: top;">
			<div id="leftDiv" style="TEXT-ALIGN: left; leftMargin:0; padding:5px 0px 10px 5px;">
			<!-------------------------------------------------------------------------------------->
			<!-- 차트 타입 메뉴 구성 -->
			<!-------------------------------------------------------------------------------------->
				<div id=tab_0 class="dtree" style="display:block; padding:0 0 0 0;overflow: auto;">
<script type="text/javascript">
	//id, pid, name, url, title, target, icon, iconOPne, open,
	ct = new dTree('ct','<%=Constances.SYSTEM_IMAGE_URL%>');
	ct.config.target="frameMain";
	ct.config.folderLinks = true;

	// --------------- System Type -------------------- //
	ct.add(0,-1,' <B>HOME</B>','<%=Constances.SYSTEM_CONTEXT_PATH %>/system/systemDefault.sys','');	//Home
<%	
	for(LoginMenuDto bigMenuDto : bigMenuList) {
        if(loginUserDto.getSvcTypeCd().equals("BUY") && !loginUserDto.isDirectMan()){
            if("BUY_ORDE_APPRO_LIST".equals(bigMenuDto.getMenuCd()) || "BUY_ORDE_APPROVAL".equals(bigMenuDto.getMenuCd())) {
                continue;
            }
        }
		List<LoginMenuDto> subMiddleMenuList = bigMenuDto.getSubMenuList();
		boolean isLeafMiddle = subMiddleMenuList.size()>0 ? false : true;
		String subMiddleUrl = isLeafMiddle ? Constances.SYSTEM_CONTEXT_PATH + bigMenuDto.getFwdPath() + "?_menuId=" + bigMenuDto.getMenuId() : "";
		if("chatting".equals(bigMenuDto.getFwdPath().trim()) && Constances.CHAT_ISUSE) {
			subMiddleUrl = "javascript:parent.topFrame.msnbgOnClick();";
		}
%>
	ct.add(<%=bigMenuDto.getMenuId() %>,0,'<%=bigMenuDto.getMenuNm() %>','<%=subMiddleUrl %>');	//대메뉴
<%
		for(LoginMenuDto middleMenuDto : subMiddleMenuList) {
			List<LoginMenuDto> subSmallMenuList = middleMenuDto.getSubMenuList();
			boolean isLeafSmall = subSmallMenuList.size()>0 ? false : true;
			String subSmallUrl = isLeafSmall ? Constances.SYSTEM_CONTEXT_PATH + middleMenuDto.getFwdPath() + "?_menuId=" + middleMenuDto.getMenuId() : "";
%>
	ct.add(<%=middleMenuDto.getMenuId() %>,<%=middleMenuDto.getParMenuId() %>,'<%=middleMenuDto.getMenuNm() %>','<%=subSmallUrl %>');	//중메뉴
<%
			for(LoginMenuDto smallMenuDto : subSmallMenuList) {
				boolean isLeafEtc = true;	//소메뉴 이하는 없는걸로 구성
				String subEtcUrl = isLeafEtc ? Constances.SYSTEM_CONTEXT_PATH + smallMenuDto.getFwdPath() + "?_menuId=" + smallMenuDto.getMenuId() : "";
%>
	ct.add(<%=smallMenuDto.getMenuId() %>,<%=smallMenuDto.getParMenuId() %>,'<%=smallMenuDto.getMenuNm() %>','<%=subEtcUrl %>');	//소메뉴
<%
			}
		}
	}
%>
<% if (loginUserDto.getLoginId().equals("XXXXXXXXXX")) { %>
    ct.add('evaluateApplication',0,'지정자재 신규업체 신청','/evaluation/evaluateApplication.sys');  //지정자재 신규공급업체 신청
<%  }   %>
<%	if(contract_flag) {	%>
	ct.add('newMaterialProprosal',0,'신규자재 제안하기','/proposal/viewProposalList.sys');	//신규자재 제안
<%	}	%>
	ct.add('participationList',0,'참여게시판','/menu/board/participation/participationList.sys');	//참여게시판
	
	document.write(ct)
</script>
				</div>
 			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div id="contractDiv">
<%	
	if(!"XXXXXXXXXX".equals(loginUserDto.getLoginId())){
		if(!"ADM".equals(loginUserDto.getSvcTypeCd())){ 
%>
				<table>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents" align="left">
							<label onclick="javascript:vocGo();" style="cursor: pointer;">고객의 소리</label>
						</td>
					</tr>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents" align="left">
							<label onclick="fnContractView('1')" style="cursor: pointer;">기본 계약서</label>
						</td>
					</tr>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents">
							<label onclick="fnContractView('2')" style="cursor: pointer;">개인정보 수집 동의서</label>
						</td>
					</tr>
<%			if(!"VEN".equals(loginUserDto.getSvcTypeCd())){%>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents">
							<label onclick="fnContractView('3')" style="cursor: pointer;">특별 계약서</label>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="contract_td_contents" colspan="2"><b><font color="#329dd2">계좌번호</font></b></td>
					</tr>
					<tr>
						<td class="contract_td_contents" colspan="2"><b><font color="#329dd2">국민은행 295401-01-159395</font></b></td>
					</tr>
					<tr>
						<td class="contract_td_contents" colspan="2"><b><font color="#329dd2">예금주 : SK텔레시스</font></b></td>
					</tr>
<%			}else if ("VEN".equals(loginUserDto.getSvcTypeCd())) {%>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents">
							<label onclick="fnContractView('4')" style="cursor: pointer;">품질관리 기준서</label>
						</td>
					</tr>
<%			} %>
				</table>
<%		}else{
%>
				<table>
					<tr>
						<td width="2" valign="middle" style="padding-left: 5px">
							<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/FR/bullet_stitle_blue.gif" style="vertical-align: middle;"/>
						</td>
						<td class="contract_td_contents" align="left">
							<label onclick="javascript:vocGo();" style="cursor: pointer;">고객의 소리</label>
						</td>
					</tr>
				</table>
<%
			}
		}
%>
				<div class="footer" style="text-align: center; font-size:small; height: 30px;">
					<a href="javascript: ct.openAll();">Open all</a> | <a href="javascript: ct.closeAll();">Close all</a>
				</div>
			</div>
		</td>
	</tr>
</table>
<form id="frm" name="frm" method="post" target="frameMain" action="http://www.bitcube.co.kr/index.jsp">
	<input type="hidden" id="smBbsFlag" name="smBbsFlag" value="true"/>
	<input type="hidden" id="enCd" name="enCd" value="SM201409170003"/>
	<input type="hidden" id="siteName" name="siteName" value="okplaza.kr"/>
</form>


<form id="frm2" name="frm2" method="post" target="frameMain" action="/menu/board/community/vocList.sys">
</form>
</body>
</html>