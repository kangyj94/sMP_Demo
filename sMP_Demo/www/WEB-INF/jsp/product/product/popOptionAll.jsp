<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">규격옵션 일괄등록<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmOption">
	<input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
    </form>
    <h3>사용방법</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tbody><tr valign="top">
	        <td height="23px" class="table_td_contents">1. 컬럼에 *로 표기된 값은 필수 입니다.</td>
	    </tr>
	    <tr valign="top">
	        <td height="23px" class="table_td_contents">
                <a href="<%=Constances.SYSTEM_IMAGE_URL%>/upload/sample/optionProductExcellUploadSample.xlsx">샘플파일 다운로드</a>
	        </td>
	    </tr>
	    <tr>
	        <td>&nbsp;</td>
	    </tr>
        <!-- tr valign="top">
            <td>
                <img src="/img/system/member_excel.gif">
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr -->
	</tbody></table>
    <span id="status" style="color: #FF0000"></span>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 엑셀업로드</button>
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
    new AjaxUpload($("#btnSave"), {
        action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/product/optionExcelUpload.sys',
        name: 'excelFile',
        data: $('#frmOption').serializeObject(),
        onSubmit: function(file, ext){
            if (! (ext && /^(xls|xlsx)$/.test(ext))){
                $('#status').text("엑셀파일만 등록 가능합니다."); // extension is not allowed 
                return false;
            }
            if(!confirm("작성한 엑셀정보을 등록하시겠습니까?")) return false;
            $('#status').text('Uploading...');
        },
        onComplete: function(file, response){
            $('#status').text('');
            reloadList5();
            reloadList6();
            $('#productPop').html('');
            $('#productPop').jqmHide();
        }
    });
});
</script>