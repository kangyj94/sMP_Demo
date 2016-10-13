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

<script type="text/javascript">
$(document).ready(function(){
   $("#buyi_tota_amou").val($.number("<%=detailInfo.getBuyi_tota_amou()%>") + " 원");
   $("#none_paym_amou").val($.number("<%=detailInfo.getNone_paym_amou()%>") + " 원");
   $("#pay_amou").focus();
   $("#regButton").click(function() { fnApply(); });
   $("#schedule_date").val('<%=CommonUtils.getCurrentDate()%>');
   
});

//날짜 조회 및 스타일
$(function(){
   $("#schedule_date").datepicker(
         {
         	showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
         }
   );
   $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
});

function fnApply(){
   var none_paym_amou = parseInt($.number("<%=detailInfo.getNone_paym_amou()%>").replace(/,/g,""));
   var context = $.trim($("#context").val()); 
   
   var schedule_date = $.trim($("#schedule_date").val());
   var schedule_amou = $.trim($("#schedule_amou").val());
   var tel_user_nm = $.trim($("#tel_user_nm").val());   

   if(context == ""){
	  alert("내용을 입력해 주세요.");     
      return;     
   }
   
   if(!confirm("등록하시겠습니까?"))return;   
   
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/savePaymentDetail.sys", 
      {
         oper:"add",
         context:context,
         schedule_date:schedule_date,
         schedule_amou:schedule_amou,
         tel_user_nm:tel_user_nm,         
         buyi_sequ_numb:'<%=detailInfo.getBuyi_sequ_numb()%>'
      },       
      
      function(arg){ 
         if(fnAjaxTransResult(arg)) {  //성공시
//             var opener = window.dialogArguments;
            window.opener.$("#list").trigger("reloadGrid");
            window.close();
         }
      }
   );    
}

</script>
</head>
<body>
   <table width="560" border="0" cellspacing="0" cellpadding="0">
      <tr>
         <td>
            <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif);">
               <tr>
        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
        				<h2>채무지급활동</h2>
        			</td>
        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
        				<a href="#;" class="jqmClose">
        				<img src="/img/contents/btn_close.png" class="jqmClose" onclick="javaScript:window.close();" >
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
                     <!-- 컨텐츠 시작 -->
                     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td colspan="4" class="table_top_line"></td>
                        </tr>
                     	<tr>
                           <td class="table_td_subject9">전표번호</td>
                           <td class="table_td_contents">
                              <%=CommonUtils.getString(detailInfo.getSap_jour_numb()) %>
                           </td>                     	
                     	</tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>                        
                        <tr>
                           <td class="table_td_subject9" width="110">공급사명</td>
                           <td class="table_td_contents">
                              <%=CommonUtils.getString(detailInfo.getVendorNm()) %>
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
                        </tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>                        
                        <tr>
                           <td class="table_td_subject9">미출금금액</td>
                           <td class="table_td_contents">
                              <input id="none_paym_amou" name="none_paym_amou" type="text" value="<%=CommonUtils.getString(detailInfo.getNone_paym_amou()) %>" size="" maxlength="50" style="width: 50%;" class="input_none" readonly="readonly" />
                           </td>
                        </tr>
						<tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>                        
                        <tr>
                           <td class="table_td_subject9">출금예정일자</td>
                           <td class="table_td_contents">
                              <input type="text" name="schedule_date" id="schedule_date" style="width: 90px; vertical-align: middle;" />
                           </td>
                        </tr>
                        
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>                        
                        <tr>
                           <td class="table_td_subject9">출금예정금액</td>
                           <td class="table_td_contents">
                              <input id="schedule_amou" name="schedule_amou" type="text" value="" size="" maxlength="15" style="width: 100%" class="blue" onkeydown="return onlyNumberForSum(event);"/>
                           </td>
                        </tr>                        
                        
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">통화자</td>
                           <td colspan="3" class="table_td_contents">
                              <input id="tel_user_nm" name="tel_user_nm" type="text" value="" size="" maxlength="50" style="width: 100%" class="blue" />
                           </td>
                        </tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">내용</td>
                           <td class="table_td_contents" colspan="3">
                              <input id="context" name="context" type="text" value="" size="" maxlength="50" style="width: 100%" class="blue" />
                           </td>
                        </tr>
                        <tr>
                           <td colspan="4" class="table_top_line"></td>
                        </tr>
                     </table>
                  </td>
                  <td width="20">
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 245px;" />
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
								<button id="regButton" type="button" class="btn btn-primary btn-sm isWriter" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-check"></i>등록</button>
								<button id="closeButton" type="button" class="btn btn-default btn-sm isWriter" onclick="javaScript:window.close();"><i class="fa fa-close"></i>닫기</button>
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
</body>
</html>