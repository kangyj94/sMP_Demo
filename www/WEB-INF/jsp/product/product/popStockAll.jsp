<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">재고수량 일괄처리<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmOption">
	<input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
    </form>
    <h3>사용방법</h3>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tbody><tr valign="top">
	        <td height="23px" class="table_td_contents">1. 엑셀다운로드를 클릭하여 현재의 재고상품 목록을 다운로드 합니다..</td>
	    </tr>
	    <tr valign="top">
	        <td height="23px" class="table_td_contents">2. 다운받은 엑셀파일을 열어 변경하고자 하는 상품의 재고증감/변경사유를 입력합니다.</td>
	    </tr>
        <tr valign="top">
            <td height="23px" class="table_td_contents">3. 엑셀파일을 저장하고 엑셀업로드를 클릭하여 수정한 엑셀파일을 선택합니다.</td>
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
       <button onclick="stockAllExcel();" class="btn btn-success btn-sm"><i class="fa fa-file-excel-o"></i> 엑셀다운로드</button>
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
        action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/product/stockExcelUpload.sys',
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
            fnSetList();
	        $('#productPop').html('');
	        $('#productPop').jqmHide();
        }
    });
});
</script>