<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.*"%>
<%
@SuppressWarnings("unchecked") List<Map> deliAreaList       = (List<Map>) request.getAttribute("deliAreaList");    // 권역
@SuppressWarnings("unchecked") List<Map> workInfoList1      = (List<Map>) request.getAttribute("workInfoList1");   // 고객유형 전체
@SuppressWarnings("unchecked") List<Map> workInfoList2      = (List<Map>) request.getAttribute("workInfoList2");   // 고객유형
@SuppressWarnings("unchecked") List<Map> branchList         = (List<Map>) request.getAttribute("branchList");      // 사업장
%>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle"><span id="popVendorNm"></span> 진열 관리<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
  <p class="Ar"><label><input id="chkAll" type="checkbox" style="vertical-align: bottom;"/> 전체지역선택</label></p>
    <form id="frmMngt">
    <input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
    <input type="hidden" name="vendorid" value="${param.vendorid}"/>
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>권역(AND)</th>
        <td id="tabDeli">
        <% for (Map code : deliAreaList) { %>
            <label class="wp100">
	            <input type="hidden" name="good_display_id" value="<%=code.get("GOOD_DISPLAY_ID") == null ? "" : code.get("GOOD_DISPLAY_ID")%>"/>
	            <input type="hidden" name="display_type_cd" value="<%=code.get("CODEVAL1")%>"/>
                <input type="hidden" name="display_type" value="10"/>
                <input type="hidden" name="del_yn" value="<%=code.get("GOOD_DISPLAY_ID") == null ? "Y":""%>"/>
                <input type="checkbox" value="<%=code.get("CODENM1")%>"<%=code.get("GOOD_DISPLAY_ID") == null ? "" : "checked"%> style="vertical-align: bottom;" /> <%=code.get("CODENM1")%>
            </label>
        <% } %>
        </td>
      </tr>
      <tr>
        <th>고객유형(AND)</th>
        <td>
          <p>
          <select id="workList" style="width:200px">
            <% for (Map code : workInfoList1) { %>
            <option value="<%=code.get("WORKID")%>"><%=code.get("WORKNM")%></option>
            <% } %>
          </select>
          <button id="btnAddWork" type="button" class="btn btn-primary btn-xs" style="vertical-align: top;">추가</button>
          </p>
          <table id="tabWork" width="100%">
            <tr>
              <th colspan="2">고객유형</th>
            </tr>
            <% for (Map code : workInfoList2) { %>
            <tr>
              <td class="workNm"><%=code.get("WORKNM")%></td>
              <td width="30" align="right">
	              <input type="hidden" name="good_display_id" value="<%=code.get("GOOD_DISPLAY_ID") == null ? "" : code.get("GOOD_DISPLAY_ID")%>"/>
	              <input type="hidden" name="display_type_cd" value="<%=code.get("WORKID")%>"/>
	              <input type="hidden" name="display_type" value="20"/>
	              <input type="hidden" name="del_yn"/>
                  <button onclick="fnDelWork(this)" type="button" class="btn btn-default btn-xs">삭제</button>
              </td>
            </tr>
            <% } %>
            <tr id="noWork1" <%=workInfoList2.size() == 0 ? "":"style='display:none'"%>>
              <td colspan="2">고객유형이 없습니다.</td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <th>사업장(OR)<br/><button id="btnAddBranch" type="button" class="btn btn-primary btn-xs">추가</button></th>
        <td><table id="tabBranch" width="100%">
          <tr>
            <th colspan="2">사업장</th>
          </tr>
            <% for (Map code : branchList) { %>
            <tr>
              <td class="branchNm"><%=code.get("BRANCHNM")%></td>
              <td width="30" align="right">
                  <input type="hidden" name="good_display_branch_id" value="<%=code.get("GOOD_DISPLAY_BRANCH_ID") == null ? "" : code.get("GOOD_DISPLAY_BRANCH_ID")%>"/>
                  <input type="hidden" name="branchid" value="<%=code.get("BRANCHID")%>"/>
                  <input type="hidden" name="del_b_yn"/>
                  <button onclick="fnDelBranch(this)" type="button" class="btn btn-default btn-xs">삭제</button>
              </td>
            </tr>
            <% } %>
            <tr id="noWork2" <%=branchList.size() == 0 ? "":"style='display:none'"%>>
              <td colspan="2">사업장이 없습니다.</td>
            </tr>
        </table></td>
      </tr>
    </table>
    </form>
    <div class="Ac mgt_10">
       <button id="btnSave" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 저장</button>
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	$('#popVendorNm').html(popVendorNm);
	
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
    $('#chkAll').click(function () {
    	$('#tabDeli input[type=checkbox]').attr('checked', this.checked);
    	$('#tabDeli input[name=del_yn]').val(this.checked ? '':'Y');
    });
    $('#tabDeli input[type=checkbox]').click(function () {
    	$(this).prev('input[name=del_yn]').val(this.checked ? '':'Y');
    });
    $('#btnAddWork').click(function () {
    	var cd = $('#workList').val();
    	var isDupl = false;
    	$('#tabWork tr:visible').each(function () {
    		isDupl = cd == $(this).find('input[name=display_type_cd]').val();
    		if (isDupl) {
    			alert('동일한 고객유형이 존재합니다. 확인바랍니다.');
    			return false;
    		}
    	});
        if (isDupl) {
            return false;
        }
    	var nm = $("#workList option:selected").text();
    	var tr = '<tr><td class="workNm">'+nm+'</td>'+
        '<td width="30" align="right"><input type="hidden" name="good_display_id"/><input type="hidden" name="display_type_cd" value="'+cd+'"/><input type="hidden" name="display_type" value="20"/><input type="hidden" name="del_yn"/><button onclick="fnDelWork(this)" type="button" class="btn btn-default btn-xs">삭제</button></td></tr>';
        $('#noWork1').hide();
        $('#tabWork').append(tr);
    });
    $('#btnAddBranch').click(function () {
        fnBuyborgDialog("BCH", "1", "", "fnCallBackClient"); 
    });
    $('#btnSave').click(function () {
    	var checked = $('#tabDeli input[type=checkbox]:checked');
    	var worked = $('#tabWork tr:visible td.workNm');
    	var branched = $('#tabBranch tr:visible td.branchNm');
    	if (checked.length > 0 && worked.length == 0) {
    		alert('권역을 하나 이상 선택하시면  고객유형을 하나 이상 선택하셔야 합니다.');
            return;
    	}
        if (checked.length == 0 && worked.length > 0) {
            alert('고객유형을 하나 이상 선택하시면  권역을 하나 이상 선택하셔야 합니다.');
            return;
        }
        if (!confirm("진열정보를 저장하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveMngt.sys', $('#frmMngt').serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  try{
            		  var deli = '';
                      checked.each(function () {
                          if (deli == '') {
                              deli = deli + $(this).val();
                          } else {
                              deli = deli + ',' + $(this).val();
                          }
                      });
                      var work = '';
                      $('#tabWork tr:visible td.workNm').each(function () {
                          if (work == '') {
                              work = work + $(this).html();
                          } else {
                              work = work + ',' + $(this).html();
                          }
                      });
                      var branch = '';
                      branched.each(function () {
                          if (branch == '') {
                              branch = branch + $(this).html();
                          } else {
                              branch = branch + ',' + $(this).html();
                          }
                      });
                      
                      var row = $('#list3').jqGrid('getGridParam','selrow');
                      $('#list3').setCell(row, "DELI", deli == '' ? '&nbsp;' : deli);
                      $('#list3').setCell(row, "WORK", work == '' ? '&nbsp;' : work);
                      $('#list3').setCell(row, "BRANCH", branch == '' ? '&nbsp;' : branch);
                      $('#productPop').html('');
                      $('#productPop').jqmHide();  
            	  }
            	  catch(e){
            		  //alert(e);
            	  }
                  
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    
});
function fnDelWork(obj) {
	var tr = $(obj).closest('tr');
	var good_display_id = tr.find('input[name=good_display_id]');
	if (good_display_id.val() == '') {
		tr.remove();
	} else {
	    tr.find('input[name=del_yn]').val('Y');
	    tr.hide();
	}
	if ($('#tabWork').find('tr:visible').length == 1) {
		$('#noWork1').show();
	}
}
function fnDelBranch(obj) {
    var tr = $(obj).closest('tr');
    var good_display_branch_id = tr.find('input[name=good_display_branch_id]');
    if (good_display_branch_id.val() == '') {
        tr.remove();
    } else {
        tr.find('input[name=del_b_yn]').val('Y');
        tr.hide();
    }
    if ($('#tabBranch').find('tr:visible').length == 1) {
        $('#noWork2').show();
    }
}
/**
 * 조직팝업검색후 선택한 값 세팅
 */
function fnCallBackClient(groupId, clientId, branchId, borgNm, areaType) {
   var isDupl = false;
   $('#tabBranch tr:visible').each(function () {
       isDupl = branchId == $(this).find('input[name=branchid]').val();
       if (isDupl) {
           alert('동일한 사업장이 존재합니다. 확인바랍니다.');
           return false;
       }
   });
   if (isDupl) {
       return false;
   }
   var tr = '<tr><td class="branchNm">'+borgNm+'</td>'+
   '<td width="30" align="right"><input type="hidden" name="good_display_branch_id"/><input type="hidden" name="branchid" value="'+branchId+'"/><input type="hidden" name="del_b_yn"/><button onclick="fnDelBranch(this)" type="button" class="btn btn-default btn-xs">삭제</button></td></tr>';
   $('#noWork2').hide();
   $('#tabBranch').append(tr);
}
</script>