<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:845px;">
<h1 id="userDialogHandle">운영사 이미지관리<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <table class="InputTable">
    <colgroup>
    	<col width="70px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>상세설명</th>
        <td><textarea id="pop_skts_good_desc" name="pop_skts_good_desc" style="height:200px;display:none;width: 100%"></textarea></td>
      </tr>
    </table>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 등록</button>
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
    $("#pop_skts_good_desc").val($('#skts_good_desc').val());
    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "pop_skts_good_desc",
        sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html"
   });
    $('#btnSave').click(function () {
        oEditors.getById["pop_skts_good_desc"].exec("UPDATE_CONTENTS_FIELD", []);
        $('#pop_skts_good_desc').val(fnReplaceAll($('#pop_skts_good_desc').val(), unescape("%uFEFF"), ""));
        $("#skts_good_desc").val($('#pop_skts_good_desc').val());
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
} 
</script>