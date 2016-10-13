<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%

%>
<table width="600" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table id="userDialogHandle" width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
				<tr>
					<td width="21" style="background-color: #ea002c; height: 47px;"></td>
					<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
						<h2>유지보수 요청</h2>
					</td>
					<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
						<a href="#;" class="jqmClose">
						<img src="/img/contents/btn_close.png" class="jqmClose">
						</a>
					</td>
					<td width="10" style="background-color: #ea002c; height: 47px;"></td>
				</tr>
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
                    <input type="hidden" name="oper" value="add"/>
                    <input type="hidden" name="idGenSvcNm" value="seqRepair"/>
                    
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="4" class="table_top_line"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">화면명</td>
                            <td class="table_td_contents4" colspan=3>
                                <input type="text" id="VIEW_NM" name="VIEW_NM" value="" required title="화면명" style="width:450px" maxlength="100"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">접수구분</td>
                            <td class="table_td_contents4">
                                <select id="TYPE" name="TYPE" style="min-width:80px;" class="select repairVal"></select>
                            </td>
                            <td class="table_td_subject9" width="60">우선순위</td>
                            <td class="table_td_contents4">
                                <select id="IS_IMPORTANT" name="IS_IMPORTANT" style="min-width:80px;" class="select repairVal">
                                	<option value="N">N</option>
                                	<option value="Y">Y</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject9" width="60">요청내용</td>
                            <td class="table_td_contents4" colspan=3>
                            	<textarea id="REQ_CONTENTS" name="REQ_CONTENTS" required title="요청내용" style="min-width:450px;height:200px;"></textarea>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" height='1' bgcolor="eaeaea"></td>
                        </tr>
                        <tr>
                            <td class="table_td_subject" width="60">첨부1</td>
                            <td class="table_td_contents4" >
                            	<input type="hidden" id="ATTACH1_ID" name="ATTACH1_ID" value=""/>
								<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
									<span id="attach_file_name3"></span>
								</a>
								<button id="btnAttach3" type="button" class="btn btn-primary btn-xs">등록</button>
								<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
                            </td>
                            <td class="table_td_subject" width="60">첨부2</td>
                            <td class="table_td_contents4" >
								<input type="hidden" id="ATTACH2_ID" name="ATTACH2_ID" value=""/>
								<input type="hidden" id="attach_file_path4" name="attach_file_path4" value=""/>
								<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
									<span id="attach_file_name4"></span>
								</a>
								<button id="btnAttach4" type="button" class="btn btn-primary btn-xs">등록</button>
								<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
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
                            <button id="btnRepairReg" type="button" class="btn btn-danger btn-sm"><i class="fa fa-save"></i> 저장</button>
                            <button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
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
	$("#repairPop").jqDrag('#userDialogHandle');
	fnDateInit();
	
	$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#ATTACH1_ID").val(), "fnCallBackAttach3"); });
	$("#btnAttach4").click(function(){ fnUploadDialog("첨부파일4", $("#ATTACH2_ID").val(), "fnCallBackAttach4"); });
	$("#btnAttachDel3").click(function(){ fnAttachDel('ATTACH1_ID'); });
	$("#btnAttachDel4").click(function(){ fnAttachDel('ATTACH2_ID'); });

	
	
	$('#btnRepairReg').click(function (e) {
		var VIEW_NM =  $("#VIEW_NM").val();
		var REQ_CONTENTS = $("#REQ_CONTENTS").val();
		var ATTACH1_ID = $("#ATTACH1_ID").val();
		var ATTACH2_ID = $("#ATTACH2_ID").val();
		
		if( ! VIEW_NM ){
			alert("화면명을 입력하여 주시기 바랍니다.");
			return;
		}		
		if( VIEW_NM.length > 201 ){
			alert("화면명은 최대 200자까지 입력 가능합니다.");
			return;
		}		
		if( ! REQ_CONTENTS ){
			alert("요청내용을 입력하여 주시기 바랍니다.");
			return;
		}		
		if( REQ_CONTENTS.length > 4000 ){
			alert("요청내용은 최대 4000자까지 입력 가능합니다.");
			return;
		}		
		
		if( ATTACH1_ID && isNaN(ATTACH1_ID) ){
			alert("첨부1 파일 정보가 잘못됐습니다.");
			return;
		}		
		
		if( ATTACH2_ID && isNaN(ATTACH2_ID) ){
			alert("첨부2 파일 정보가 잘못됐습니다.");
			return;
		}		
		
		if (!confirm(" '등록' 처리하시겠습니까?")) return;
		$.post(
			'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/insertRepairManage/save.sys',
			$('#frm').serialize(),
			function(msg) {
				var m = eval('(' + msg + ')');
				if (m.customResponse.success) {
					$("#repairDetail").hide();
					fnSearch();
					$('#repairPop').html('');
					$('#repairPop').jqmHide();
				} else {
					alert('저장 중 오류가 발생했습니다.');
				}
			}
		);  
	});
	$('.jqmClose').click(function (e) {
		$('#repairPop').html('');
		$('#repairPop').jqmHide();
	});
	    
	$.post(  //조회조건의 faq유형 세팅
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
		{
			codeTypeCd : "REPAIR_TYPE",
			isUse      : "1"
		},
		function(arg){
			var codeList = eval('(' + arg + ')').codeList;
			
			for(var i=0;i<codeList.length;i++) {
				$("#TYPE").append("<option value='"+codeList[i].codeVal1+"'>"+codeList[i].codeNm1+"</option>");
			}
		}
	);
});
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
