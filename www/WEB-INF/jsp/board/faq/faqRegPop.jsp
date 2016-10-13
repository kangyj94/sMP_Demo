<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%
String periodFrom = CommonUtils.getCurrentDate();
String periodTo = CommonUtils.getCustomDay("MONTH", 1);
%>
<table width="600" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>FAQ관리 ${empty faq ? '등록':'수정'}</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
		</table>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" /></td>
                <td width="100%"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif" width="100%" height="20" /></td>
                <td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
            </tr>
			<tr>
                <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                <td valign="top" bgcolor="#FFFFFF">
                    <form id="frm" name="frm" method="post" onsubmit="return false;">
                    <input type="hidden" name="oper" value="${empty faq ? 'add':'edit'}"/>
                    <input type="hidden" name="idGenSvcNm" value="seqFaq"/>
                    <input type="hidden" name="FAQ_SEQ" value="${faq.FAQ_SEQ}"/>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="70">제목</td>
                            <td class="table_td_contents4" colspan=3>
                                <input type="text" id="TITLE" name="TITLE" value="${faq.TITLE}" required title="제목" style="width:450px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="70">FAQ유형</td>
                            <td class="table_td_contents4">
                                <select id="FAQ_TYPE" name="FAQ_TYPE">
                                    <option value="">선택</option>
                                </select>
                            </td>
                            <td class="table_td_subject9" width="70">서비스유형</td>
                            <td class="table_td_contents4">
		                        <select id="SVC_TYPE" name="SVC_TYPE">
		                            <option value="">선택</option>
                                    <option value="BUY">고객사</option>
                                    <option value="VEN">공급사</option>
                                </select>
                            </td>
                        </tr>
                        <tr><td colspan="4" height='1' bgcolor="eaeaea"></td></tr>
                        <tr>
                            <td class="table_td_subject9" style="vertical-align:top;" width="70">내용</td>
                            <td class="table_td_contents4" colspan=3>
                            	<textarea id="ANSWER" name="ANSWER" required title="상세설명" style="min-width:450px;height:200px;display:none">${faq.ANSWER}</textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                    </table> 
                    </form>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center">
								<button id="btnSave" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-save"></i>저장</button>
								<button id="btnClose" type="button" class="btn btn-default btn-sm isWriter jqmClose"><i class="fa fa-close"></i>닫기</button>
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
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
var oEditors = [];
$(function() {
    $("#pollPop").jqDrag('#userDialogHandle');
    fnDateInit();
    $('#btnSave').click(function (e) {

		oEditors.getById["ANSWER"].exec("UPDATE_CONTENTS_FIELD", []);
		
		var title =  $("#TITLE").val();
		var faq_type = $("#FAQ_TYPE").val();
		var svc_type = $("#SVC_TYPE").val();
		var answer = $("#ANSWER").val();
		
		if( ! title ){
			alert("제목을 입력하여 주시기 바랍니다.");
			return;
		}		
		
		if( ! faq_type ){
			alert("FAQ유형을 선택하여 주시기 바랍니다.");
			return;
		}		
		
		if( ! svc_type ){
			alert("서비스 유형을 선택하여 주시기 바랍니다.");
			return;
		}		
		
		if( ! title ){
			alert("제목을 입력하여 주시기 바랍니다.");
			return;
		}		
		
		if( ! answer || answer == '<p>&nbsp;</p>'){
			alert("내용을 입력하여 주시기 바랍니다.");
			return;
		}		
		
		if( answer.length > 400){
			alert("내용이 너무 깁니다");
			return;
		}		
		
        if (!confirm("${empty faq ? '등록':'수정'} 처리하시겠습니까?")) return;
        
        answer = fnReplaceAll(answer, unescape("%uFEFF"), "");
        
    	$.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/board/${empty faq ? "insert":"update"}FaqManage/save.sys', $('#frm').serialize(),
	        function(msg) {
    		  var m = eval('(' + msg + ')');
    		  if (m.customResponse.success) {
    			  fnSearch();
    			  $('#faqPop').html('');
    		      $('#faqPop').jqmHide();
    		  } else {
    			  alert('저장 중 오류가 발생했습니다.');
    		  }
	        }
	    );  
    });
	$('.jqmClose').click(function (e) {
        $('#faqPop').html('');
		$('#faqPop').jqmHide();
	});
	

    nhn.husky.EZCreator.createInIFrame({
    	 oAppRef: oEditors,
    	 elPlaceHolder: "ANSWER",
    	 sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
    });
    
    
});

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 

//날짜 데이터 초기화 
function fnDateInit() {
	//코드 데이터 초기화 
		$.post(  //조회조건의 faq유형 및 서비스유형 세팅
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
			{
				codeTypeCd:"FAQ_TYPE",
				isUse:"1"
			},
			function(arg){
				var codeList = eval('(' + arg + ')').codeList;
				for(var i=0;i<codeList.length;i++) {
					$("#FAQ_TYPE").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
				}
				$("#FAQ_TYPE").val("${faq.FAQ_TYPE}");
				$("#SVC_TYPE").val("${faq.SVC_TYPE}");
			}
		); 
}
</script>
