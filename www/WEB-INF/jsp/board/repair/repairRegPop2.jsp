<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<div id="divPopup" style="width:600px;">
	<h1>유지보수 요청<a href="#"><img src="/img/contents/btn_close.png" class="jqmClose" /></a></h1>
	<div class="popcont">
		<form id="frm" name="frm" onsubmit="return false;">
			<input type="hidden" name="oper" value="add"/>
			<input type="hidden" name="idGenSvcNm" value="seqRepair"/>
		<table class="InputTable">
			<tr>
				<th>화면명</th>
				<td colspan=3>
					<input type="text" id="VIEW_NM" name="VIEW_NM" value="" required title="화면명" style="width:450px" maxlength="100"/>
				</td>
			</tr>
			<tr>
				<th width="60">접수구분</th>
				<td colspan=3>
					<select id="TYPE" name="TYPE" style="min-width:80px;" class="select repairVal"></select>
				</td>
			</tr>
			<tr>
				<th width="60">요청내용</th>
				<td colspan=3>
					<textarea id="REQ_CONTENTS" name="REQ_CONTENTS" required title="요청내용" style="min-width:450px;height:200px;"></textarea>
				</td>
			</tr>
			<tr>
				<th width="60">첨부1</th>
				<td>
					<input type="hidden" id="ATTACH1_ID" name="ATTACH1_ID" value=""/>
					<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
					<a href="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
						<span id="attach_file_name3"></span>
					</a>
					<div style="float:right">
					<button id="btnAttach3" type="button" class="btn btn-darkgray btn-xs">등록</button>
					<button id="btnAttachDel3" type="button" class="btn btn-default btn-xs">삭제</button>
					</div>
				</td>
				<th width="60">첨부2</th>
				<td>
					<input type="hidden" id="ATTACH2_ID" name="ATTACH2_ID" value=""/>
					<input type="hidden" id="attach_file_path4" name="attach_file_path4" value=""/>
					<a href="javascript:fnAttachFileDownload($('#attach_file_path4').val());">
						<span id="attach_file_name4"></span>
					</a>
					<div style="float:right">
					<button id="btnAttach4" type="button" class="btn btn-darkgray btn-xs">등록</button>
					<button id="btnAttachDel4" type="button" class="btn btn-default btn-xs">삭제</button>
					</div>
				</td>
			</tr>
		</table>
		</form>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td align="center">
					<button id="btnRepairReg" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-save"></i> 저장</button>
					<button id="btnClose" type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
				</td>
			</tr>
		</table>
	</div>
</div>


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
		
		$('#repairPop').jqmHide();
		confirmMessage(" '등록' 처리하시겠습니까?", fnBtnRepairRegOnClickCallback); // confirm 호출
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

function fnBtnRepairRegOnClickCallback(){
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH %>/board/insertRepairManage.sys',
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
