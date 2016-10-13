<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 700px;
    
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}

.jqmOverlay { background-color: #000; } 

* html .jqmWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>

<!-------------------------------- Dialog Div Start -------------------------------->
<script type="text/javascript">
$(function(){
   $('#reasonDialogPop').jqm();  //Dialog 초기화
   $("#saveJqmButton").click(function(){
    	 $("#saveJqmReasonField").val($("#saveJqmReasonField").val().replace(/\n/g,"<br>"));
         fnJqmSaveJqmReasonField();
         $('#reasonDialogPop').hide();
   });
   
   $("#closeButton").click(function(){ //Dialog 닫기
//       if(confirm("주문상태를 변경하려면 변경사유를 반드시 입력해야합니다.\n수정사유 입력을 중단하시겠습니까?")){
         eval(fnStatChangeReasonCallback+"_cancel" +"();");
//          fnStatChangeReasonCancelCallback();
         $('#reasonDialogPop').hide();
//       }
   });
});

var fnStatChangeReasonCallback = "";
function fnStatChangeReasonDialog(callbackString) {
   $("#reasonDialogPop").show();
   fnStatChangeReasonCallback=  callbackString;
}
/**
 * 변경사유 입력후 Callback 호출
 */
function fnJqmSaveJqmReasonField() {
   $("#saveJqmReasonField").val($.trim($("#saveJqmReasonField").val()));
   if($("#saveJqmReasonField").val() == ""){
	  eval(fnStatChangeReasonCallback+"_cancel" +"();");
//       fnStatChangeReasonCancelCallback();
      alert("변경사유를 입력해주십시오.");
   }else{
      eval(fnStatChangeReasonCallback +"(\""+$('#saveJqmReasonField').val()+"\");");
      $("#reasonDialogPop").hide();
      fnStatChangeReasonCallback = "";
      $('#saveJqmReasonField').val("");
   }
}
</script>
</head>
<body>
<div class="jqmWindow" id="reasonDialogPop">
      <table width="700" border="0" cellspacing="0" cellpadding="0">
         <tr>
            <td>
                     <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                  <tr>
        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-size: 14px;font-weight: 700;"><h3>변경사유</h3></td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
                  </tr>
               </table>
                  <table width="100%"  border="0" cellpadding="0" cellspacing="0" >
                  <tr>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                     <td valign="top" bgcolor="#FFFFFF">
                        <table width="100%" class="InputTable" style="margin-top: 10px;">
                           <tr>
                              <th  width="100">사유</th>
                              <td>
                              	<textarea name="textarea" id="saveJqmReasonField" cols="45" rows="10" style="width: 98%; height: 50px"></textarea>
                              </td>
                           </tr>
                        </table> 
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                           <tr>
                              <td>&nbsp;</td>
                           </tr>
                           <tr>
                              <td align="center">
                              
										<button id="saveJqmButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>등록</button>
										<button id="closeButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
<%--                                     <a href="#"><img id="saveJqmButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_register.gif" style='border:0;' /></a> --%>
<%--                                     <a href="#"><img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style='border:0;' /></a> --%>
                              </td>
                           </tr>
                        </table> 
                     </td>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                  </tr>
                  <tr>
                        <td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
                        <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                        <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
                  </tr>
               </table></td>
         </tr>
      </table>
   </div>
<!-------------------------------- Dialog Div End -------------------------------->
</body>
</html>