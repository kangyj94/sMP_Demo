<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
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
   String crea_sale_date = CommonUtils.getCurrentDate();
   
   LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   String userId = request.getParameter("userId");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="">
$(document).ready(function(){
   $("#crea_sale_date").val('<%=crea_sale_date%>');
   $("#delClientBtn").click( function() { fnDelClientNm(); });
   $("#regButton").click( function() { fnRegist(); });
    
$.post(
   '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
    {codeTypeCd:"ORDERTYPECODE", isUse:"1"},
    function(arg){
      var codeList = eval('(' + arg + ')').codeList;
         for(var i=0;i<codeList.length;i++) {
               $("#srcOrderTypeCd").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
            }
         }
      ); 

   $.post(
      '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {codeTypeCd:"PAYMCONDCODE", isUse:"1"},
         function(arg){
         var codeList = eval('(' + arg + ')').codeList;
         for(var i=0;i<codeList.length;i++) {
               $("#paym_cond_code").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
            }
         $("#paym_cond_code").val("1030");
         }
      ); 
});

$(function(){
   $("#crea_sale_date").datepicker(
      {
         showOn: "button",
        buttonImage: "/img/system/btn_icon_calendar.gif",
        buttonImageOnly: true,
        dateFormat: "yy-mm-dd"
      }
   );
   $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});    

</script>
<%
/**------------------------------------고객사팝업 사용방법---------------------------------
* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
* borgNm : 찾고자하는 고객사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 5개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String, 권역코드) 
*/
%>
<%-- <%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%> --%>
<%@ include file="/WEB-INF/jsp/adjust/adjustBorgDialog.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#srcClientBtn").click(function(){
//  		fnBuyborgDialog("", "", "", "fnCallBackClient");
		var userId = '<%=userId%>';
		fnAdjustBorgDialog("BCH", "1", "", "fnCallBackClient",userId);	


});
   <%
	//	공급사 정산일경우 고객사는 SK브로드밴드로 고정되야함
	//	개발현재(2013-01-23) Default Value 를 셋팅
	//	추후 변경요망!!!!!!!!!!!!!!
	if("VEN".equals( userInfoDto.getSvcTypeCd())){

%>
	$("#borgNm").removeClass();
	$("#borgNm").addClass("input_text_none");
	$("#srcClientBtn").hide();
	$("#delClientBtn").hide();
	$("#borgNm").val("SK그룹 > SK브로드밴드");
	$("#srcClientId").val("304453");	
	$("#srcBranchId").val("0");	
<%		
	}
%>


});
</script>

<script type="text/javascript">

/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
	if(clientId == '' && branchId == '') {
		alert("그룹레벨은 선택하실수 없습니다.");
		return;
	} 
	var srcBranchId = "";
	if($.trim(branchId).length == 0) srcBranchId = "0";
	else							 srcBranchId = branchId;
// 	var borgId = "";
// 	if(branchId != '')		borgId = branchId;
// 	else					borgId = clientId;
   	$("#borgNm").val(borgNm);
   	$("#srcClientId").val(clientId);
   	$("#srcBranchId").val(srcBranchId);
}
</script>
<% //------------------------------------------------------------------------------ %>


<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnDelClientNm() {
   $("#borgNm").val("");
   $("#srcClientId").val("");
   $("#srcBranchId").val("");
}

function fnRegist(){
   var srcClientId      = $.trim($("#srcClientId").val());
   var srcBranchId      = $.trim($("#srcBranchId").val());
   var sale_sequ_name   = $.trim($("#sale_sequ_name").val());
   var crea_sale_date  = $.trim($("#crea_sale_date").val());
   var paym_cond_code   = $.trim($("#paym_cond_code").val());
   
   if(sale_sequ_name == ""){
	   $("#dialog").html("<font size='2'>정산명을 입력해주세요.</font>");
	  $("#dialog").dialog({
	  	  title: 'Success',modal: true,
		  buttons: {"Ok": function(){$(this).dialog("close");} }
	  });		   
      return;
   }   
   
   if(srcClientId == ""){
	  $("#dialog").html("<font size='2'>세금계산서 고객사를 선택해주세요.</font>");
	  $("#dialog").dialog({
	  	  title: 'Success',modal: true,
		  buttons: {"Ok": function(){$(this).dialog("close");} }
	  });			      
      return;
   }

   if(crea_sale_date == ""){
	  $("#dialog").html("<font size='2'>정산 생성일자를 입력해주세요.</font>");
	  $("#dialog").dialog({
	  	  title: 'Success',modal: true,
		  buttons: {"Ok": function(){$(this).dialog("close");} }
	  });		   
      return;
   }
  
   if(paym_cond_code == ""){
	  $("#dialog").html("<font size='2'>지급조건을 선택해주세요.</font>");
	  $("#dialog").dialog({
	  	  title: 'Success',modal: true,
		  buttons: {"Ok": function(){$(this).dialog("close");} }
	  });		   
      return;
   }
   
   $.post(
  	  "<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveAdjustMaster.sys", 
   	  {
      	oper:"add",
      	clientId:srcClientId,
      	branchId:srcBranchId,
      	sale_sequ_name:$("#sale_sequ_name").val(),
      	crea_sale_date:$("#crea_sale_date").val(),
      	paym_cond_code:$("#paym_cond_code").val()
      },       
         
      function(arg){ 
         if(fnAjaxTransResult(arg)) {  //성공시
//             var opener = window.dialogArguments;
            window.opener.$("#list3").trigger("reloadGrid");
            window.close();
         }
      }
   );    
}

</script>
</head>

<body>
   <table width="700" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
               <tr>
		           <td width="21" style="background-color: #ea002c; height: 47px;"></td>
		           <td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		           	<h2>정산생성</h2>
		           </td>
		           <td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		           	<a href="#;" class="jqmClose">
		           	<img src="/img/contents/btn_close.png" class="jqmClose">
		           	</a>
		           </td>
		           <td width="10" style="background-color: #ea002c; height: 47px;"></td>
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
                     <!-- 타이틀 시작 -->
                     <table width="100%" border="0" cellpadding="0" cellspacing="0" style="height: 27px;">
                        <tr>
                           <td width="20" valign="top">
                              <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                           </td>
                           <td class="stitle">정산 내용</td>
                           <td align="right"></td>
                        </tr>
                     </table>
                     <!-- 타이틀 끝 -->
                     <!-- 컨텐츠 시작 -->
                     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td colspan="2" class="table_top_line"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9" width="110">정산명</td>
                           <td class="table_td_contents">
                              <input id="sale_sequ_name" name="sale_sequ_name" type="text" value="" size="" maxlength="50" style="width: 80%" class="blue" />
                           </td>
                        </tr>
                        <tr>
                           <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">세금계산서 고객사</td>
                           <td class="table_td_contents">
                              <input id="borgNm" name="borgNm" type="text" value="" size="" maxlength="50" style="width: 400px;" class="blue" disabled="disabled" />
                              <input id="srcClientId" name="srcClientId" type="hidden" value="" size="" maxlength="50" style="width: 400px;" class="blue" />
                              <input id="srcBranchId" name="srcBranchId" type="hidden" value="" size="" maxlength="50" style="width: 400px;" class="blue" />
                              <a href="#">
                                 <img id="srcClientBtn" name="srcClientBtn" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; vertical-align: middle; border: 0px;" class="icon_search" />
                              </a>
                              <a href="#"> 
                                 <img id="delClientBtn" name="delClientBtn" src="/img/system/btn_icon_minus.gif" width="20" height="18" style="border: 0px; vertical-align: middle;"/>
                              </a>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">정산 생성일자</td>
                           <td class="table_td_contents">
                              <input type="text" name="crea_sale_date" id="crea_sale_date" style="width: 75px;vertical-align: middle;" /> 
                           </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr style="display:none;">
                           <td colspan="2" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr style="display:none;">
                           <td class="table_td_subject9">지급조건</td>
                           <td class="table_td_contents">
                              <select class="select" id="paym_cond_code" name="paym_cond_code">
                                 <option>선택하세요</option>
                              </select>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="2" class="table_top_line"></td>
                        </tr>
                     </table>
                  </td>
                  <td width="20">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 150px;" />
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
                              <button id="regButton" type="button" class="btn btn-danger btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 저장</button>
                              <button id="closeButton" type="button" class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" onclick="javaScript:window.close();"><i class="fa fa-times"></i> 닫기</button>
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
   <div id="dialog" title="Feature not supported" style="display:none;">
      <p>That feature is not supported.</p>
    </div>
</body>
</html>