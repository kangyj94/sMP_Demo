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
   String crea_sale_date = CommonUtils.getCurrentDate();
   AdjustDto detailInfo = (AdjustDto)request.getAttribute("detailInfo");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">
$(document).ready(function(){
   $("#sale_tota_amou").val($.number("<%=detailInfo.getSale_tota_amou()%>") + " 원");
   $("#none_coll_amou").val($.number("<%=detailInfo.getNone_coll_amou()%>") + " 원");
   $("#pay_amou").focus();
   $("#regButton").click(function() { fnApply(); });
   $("#payDate").val('<%=crea_sale_date%>');
   
});

function fnApply(){
   var none_coll_amou = parseInt($.number("<%=detailInfo.getNone_coll_amou()%>").replace(/,/g,""));
   var pay_amou = $.trim($("#pay_amou").val()); 
   var payDate = $("#payDate").val(); 
   
   if(parseInt(none_coll_amou) < parseInt(pay_amou)){
      $("#dialog").html("<font size='2'>입금금액이 미회수금액보다 많습니다.</font><br><br><font size='2'>확인후 다시 입력해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });         
      $("#pay_amou").focus();
      return;     	   
   } 
   
   
   if(pay_amou == ""){
      $("#dialog").html("<font size='2'>입금금액을 입력해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });        
      $("#pay_amou").focus();
      return;     
   }
   
   if(payDate == ""){
      $("#dialog").html("<font size='2'>입금일자를 입력해주세요.</font>");
      $("#dialog").dialog({
         title: 'Fail',modal: true,
         buttons: {"Ok": function(){$(this).dialog("close");} }
      });         
      $("#payDate").focus();
      return;     
   }   
   
   if(!confirm("등록하시겠습니까?"))return;
      
   $.post(
      "<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/saveDepositDetail.sys", 
      {
         oper:"add",
         pay_amou:pay_amou,											//입금금액
         payDate:payDate,											//입금일
         none_coll_amou:none_coll_amou,								//미회수금액
         sale_sequ_numb:'<%=detailInfo.getSale_sequ_numb()%>',
         alramUserId:$("#alramUserId").val()
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

//날짜 조회 및 스타일
$(function(){
   $("#payDate").datepicker(
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
</head>
<body>
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
                  <td class="popup_title">매출입금내역</td>
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
                           <td class="table_td_subject9" width="110">정산명</td>
                           <td class="table_td_contents">
                              <%=CommonUtils.getString(detailInfo.getSale_sequ_name()) %>
                           </td>
                           <td class="table_td_subject9" width="110">전표번호</td>
                           <td class="table_td_contents">
                              <%=CommonUtils.getString(detailInfo.getSap_jour_numb()) %>
                           </td>
                        </tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">세금계산서 고객사</td>
                           <td class="table_td_contents">
                              <%=CommonUtils.getString(detailInfo.getClientNm()) %>
                           </td>
                           <td class="table_td_subject9">입금일자</td>
                           <td class="table_td_contents">
                              <input type="text" name="payDate" id="payDate" style="width: 90px; vertical-align: middle;" />
                           </td>
                        </tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                           <td class="table_td_subject9">매출합계</td>
                           <td class="table_td_contents">
                              <input id="sale_tota_amou" name="sale_tota_amou" type="text" value="<%=CommonUtils.getString(detailInfo.getSale_tota_amou()) %>" size="" maxlength="50" style="width: 100%;" class="input_none" readonly="readonly" />
                           </td>
                                                   
                           
                        </tr>
                        <tr>
                           <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>                        
                        <tr>
                           <td class="table_td_subject9">미회수금액</td>
                           <td class="table_td_contents">
                              <input id="none_coll_amou" name="none_coll_amou" type="text" value="<%=CommonUtils.getString(detailInfo.getNone_coll_amou()) %>" size="" maxlength="40" style="width: 100%;" class="input_none" readonly="readonly" />
                           </td>
                           
                           <td class="table_td_subject9">입금금액</td>
                           <td class="table_td_contents">
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
                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif" style="width: 20px; height: 130px;" />
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
                              <a href="#"> 
                                 <img id="closeButton" name="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="width: 65px; height: 23px; border: 0px;" onclick="javaScript:window.close();"/>
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
   <div id="dialog" title="Feature not supported" style="display:none;">
      <p>That feature is not supported.</p>
   </div>         
</body>
</html>