<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-200 + Number(gridHeightResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
// 	List<Map<String, Object>> contractSpecialList = (List<Map<String, Object>>)request.getAttribute("contractSpecialList");

	String getDate = CommonUtils.getCurrentDate().substring(0, 10);
	String contractNo = "";
	String contractVersion = "";
	String contractClassify = "";
	String contractContents = "";
	String contractDate = "";
	String contractUserNm = "";
	String contractVersion1 = "";
	String contractVersion2 = "";
	String contractSpecial = "";
	Map<String, Object> contractDetail = (Map<String, Object>)request.getAttribute("contractDetail");
	if(contractDetail != null){
		contractNo = contractDetail.get("contractNo").toString();
		contractVersion = (String)contractDetail.get("contractVersion");
		contractClassify = (String)contractDetail.get("contractClassify");
		contractContents = (String)contractDetail.get("contractContents");
		contractDate = (String)contractDetail.get("contractDate");
		contractUserNm = (String)contractDetail.get("contractUserNm");
		contractSpecial = (String)contractDetail.get("contractSpecial");
		contractVersion2 = contractVersion.substring(8);
		if(contractVersion.indexOf("B") >= 0){
			contractVersion1 = "10";
		}else if(contractVersion.indexOf("I") >= 0){
			contractVersion1 = "20";
		}else if(contractVersion.indexOf("S") >= 0){
			contractVersion1 = "30";
		}else if(contractVersion.indexOf("Q") >= 0){
			contractVersion1 = "40";
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function(){
	$("#regButton").click(function(){ fnSave(); });
	$("#modButton").click(function(){ fnSave(); });
	$("#closeButton").click(function(){ fnClose(); });
	contractVersonInfo();//계약구분에 따른 계약버전만들기
	if("<%=contractNo%>" !=""){
		fnDetail();
	}

});

function contractVersion() {
	var version = $("#contractVersion1").val();
	var contractSpecial = "<%=contractSpecial%>";
	if(version == "30"){
		$.post(
			"/organ/contractSpecialList.sys",
			function(arg){
				var result = eval("("+arg+")");
				$("#contarctClassifyTR").append("<td class='table_td_subject' id='specialContrarctTD1'>특별계약</td>");
				$("#contarctClassifyTR").append("<td class='table_td_contents' id='specialContrarctTD2'><select id='contractSpecial'></select></td>");
				$("#contractSpecial").append("<option value=''>선택하세요.</option>");
				for(var i=0; i<result.list.length; i++){
					$("#contractSpecial").append("<option value='"+result.list[i].codeVal1+"'>"+result.list[i].codeNm1+"</option>");
				}
				if(contractSpecial != "null"){					
					$("#contractSpecial").val(contractSpecial);
				}
				$("#contractClassify").val('BUY');
				$("#contractClassify").attr('disabled',true);
			}
		);
	}else{
		$("#specialContrarctTD1").remove();
		$("#specialContrarctTD2").remove();
		$("#contractClassify").val('BUY');
		$("#contractClassify").attr('disabled',false);
	}
}

function fnValidator() {
	var contractVersion1 = $("#contractVersion1").val();//계약버전1
	var contractVersion2 = $("#contractVersion2").val();//계약버전2
	var contractContents = Editor.getContent();//내용
	if(contractVersion2 == ""){
		alert("계약버전을 입력해주세요.");
		return false;
	}
	
	if(contractVersion1 == "30"){
		var specialContrarct = $("#specialContrarct").val();
		if(specialContrarct == ""){
			alert("특별 계약을 선택해주세요");
			return false;	
		}
	}
	var validator = new Trex.Validator();
	if (!validator.exists(contractContents)) {
		alert("계약 내용을 입력해주세요.");
		return false;
	}

	return true;
}

function fnSave() {
	if(fnValidator()){
		var contractVersion1 = $("#contractVersion1").val();//계약버전1
		var contractVersion2 = $("#contractVersion2").val();//계약버전2
		var contractContents = Editor.getContent();//계약내용
		var contractUserNm = $("#userNm").val();//계약자
		var contractRegDate = $("#regDate").val();//계약일시
		var contractClassify = $("select[name=contractClassify]").val();
		alert(contractClassify);
		var contractSpecial = $("#contractSpecial").val();//특별계약
		var oper = $("#oper").val();
		var contractNo = "<%=contractNo%>";
		$.post(
			"/system/systemContractSave.sys",
			{
				contractVersion1:contractVersion1
				,contractVersion2:contractVersion2
				,contractContents:contractContents
				,contractUserNm:contractUserNm
				,contractRegDate:contractRegDate
				,contractSpecial:contractSpecial
				,contractClassify:contractClassify
				,oper:oper
				,contractNo:contractNo
			},
			function(arg){
				var result = eval('(' + arg + ')').customResponse; 
				var errors = "";
				if (result.success == false) {
					for (var i = 0; i < result.message.length; i++) {
						errors +=  result.message[i] + "<br/>";
					}
					alert(errors);
				}else{
					alert("처리 하였습니다.");
					window.opener.fnReloadGrid();
					fnClose();
				}
			}
		);
	}
}
function fnClose() {
	window.close();
}

function fnDetail() {
<%	if(contractDetail != null){%>
		$("#contractClassify > option[value='<%=contractClassify%>']").attr("selected", true);
		contractVersonInfo();
		$("#regDate").val("<%=contractDate%>");
		$("#userNm").val("<%=contractUserNm%>");
		$("#contractVersion1 > option[value='<%=contractVersion1%>']").attr("selected", true);
<%		if("30".equals(contractVersion1)){%>
			contractVersion();
<%		}	%>
		$("#contractVersion2").val("<%=contractVersion2%>");		
		$("#contractSpecial").val("<%=contractSpecial%>");
	<%}%>
}


/**
 * Editor.save()를 호출한 경우 데이터가 유효한지 검사하기 위해 부르는 콜백함수로
 * 상황에 맞게 수정하여 사용한다.
 * 모든 데이터가 유효할 경우에 true를 리턴한다.
 * @function
 * @param {Object} editor - 에디터에서 넘겨주는 editor 객체
 * @returns {Boolean} 모든 데이터가 유효할 경우에 true
 */
function validForm(editor) {
// Place your validation logic here
	var frm     = document.getElementById("frm");
	var title   = document.getElementById("title");
	
	if(title.value == ""){
		alert("제목을 입력해 주십시오.");
		title.focus();
		
		return;
	}
       var validator = new Trex.Validator();
       var desc = editor.getContent();
       if (!validator.exists(desc)) {
           alert('내용을 입력해 주십시요');
           return false;
       }
	return true;
}

/**
 * Editor.save()를 호출한 경우 validForm callback 이 수행된 이후
 * 실제 form submit을 위해 form 필드를 생성, 변경하기 위해 부르는 콜백함수로
 * 각자 상황에 맞게 적절히 응용하여 사용한다.
 * @function
 * @param {Object} editor - 에디터에서 넘겨주는 editor 객체
 * @returns {Boolean} 정상적인 경우에 true
 */
function setForm(editor) {
	var formGenerator = editor.getForm();
	var desc = editor.getContent();
		formGenerator.createField(
		tx.textarea({
		    'name': "desc", // 본문 내용을 필드를 생성하여 값을 할당하는 부분
		    'style': { 'display': "none" }
		}, desc)
	);
		/* 아래의 코드는 첨부된 데이터를 필드를 생성하여 값을 할당하는 부분으로 상황에 맞게 수정하여 사용한다.
		 첨부된 데이터 중에 주어진 종류(image,file..)에 해당하는 것만 배열로 넘겨준다. */
		var images = editor.getAttachments('image');
		for (var i = 0, len = images.length; i < len; i++) {
	    // existStage는 현재 본문에 존재하는지 여부
		if (images[i].existStage) {
	    // data는 팝업에서 execAttach 등을 통해 넘긴 데이터
		    formGenerator.createField(
			tx.input({
			    'type': "hidden",
			    'name': 'tx_attach_image',
			    'value': images[i].data.imageurl // 예에서는 이미지경로만 받아서 사용
			}));
		}
	}
		var files = editor.getAttachments('file');
		for (var i = 0, len = files.length; i < len; i++) {
			formGenerator.createField(
			tx.input({
			    'type': "hidden",
			    'name': 'tx_attach_file',
			    'value': files[i].data.attachurl
			})
		);
	}
	return true;
}

function contractVersonInfo(){
	var contractClassify = $("select[name=contractClassify]").val();
	if(contractClassify == "VEN"){
		$("#specialContrarctTD1").remove();
		$("#specialContrarctTD2").remove();
		$("#contractVersion1").empty();
		$("#contractVersion1").append("<option value='10'>기본</option>");
		$("#contractVersion1").append("<option value='20'>개인</option>");
		$("#contractVersion1").append("<option value='40'>품질</option>");
	}else if(contractClassify == "BUY"){
		$("#contractVersion1").empty();
		$("#contractVersion1").append("<option value='10'>기본</option>");
		$("#contractVersion1").append("<option value='20'>개인</option>");
		$("#contractVersion1").append("<option value='30'>특별</option>");
	}
}
	

</script>
</head>
<body onload="loadContent(); ">
<form name="frm" id="frm">
<input type="hidden" name="oper" id="oper" value="<%=!"".equals(contractNo) ? "mod" : "save"%>" /> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>물품공급 계약서 작성</td>
				</tr>
			</table>    
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
				<tr id="contarctClassifyTR">
					<td class="table_td_subject">계약버전</td>
					<td class="table_td_contents">
						<select id="contractVersion1" onchange="contractVersion();">
						</select>
						<input type="text" id="contractVersion2" name="contractVersion2" style="width:100px;"/> 예)1.0
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">계약구분</td>
					<td class="table_td_contents">
						<select id="contractClassify" name="contractClassify" onchange="contractVersonInfo();">
							<option value="BUY">고객사</option>
							<option value="VEN">공급사</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">내용</td>
					<td colspan="3" height="150" class="table_td_contents4">
						<%@ include file = "/daumeditor/editorbox.jsp" %>
					</td> 
				</tr>
				<tr>
					<td colspan="4" height='1' bgcolor="eaeaea"></td>
				</tr>
<%			if(!"".equals(contractNo)){%>
				<tr>
					<td width="100" class="table_td_subject" width="20%">등록자</td>
					<td class="table_td_contents" width="40%">
						<input type="text" id="userNm" name="userNm" value="" style="border: none;" disabled="disabled" />
					</td>
					<td width="100" class="table_td_subject" width="20%">등록일</td>
					<td class="table_td_contents" width="40%">
						<input type="text" id="regDate" name="regDate" value="" style="border: none;" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td colspan="4" class="table_top_line"></td>
				</tr>
<%			} %>
			</table>    
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="center">
<%		if("".equals(contractNo)){%>
			<span id="regButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_save.gif" width="65" height="23" /> </span>
<%		}else{%>
			<span id="modButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_modify.gif" width="65" height="23" /> </span>
<%		}%>
			<span id="closeButton" style="cursor:pointer;"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" width="65" height="23" /></span>
		</td>
	</tr>
</table>
</form>

<textarea id="tx_load_content" cols="80" rows="10" style="display:none;"><%=contractContents%></textarea> <!--  daumEditor 수정 시 내용 가져올 때 필수 조건 -->
</body>
</html>