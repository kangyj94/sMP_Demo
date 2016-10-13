<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.*"%>
<%
@SuppressWarnings("unchecked") List<CodesDto> deliAreaList       = (List<CodesDto>) request.getAttribute("deliAreaList");    // 권역
@SuppressWarnings("unchecked") List<Map> workInfoList1      = (List<Map>) request.getAttribute("workInfoList1");   // 고객유형 전체
@SuppressWarnings("unchecked") List<Map> workInfoList2      = (List<Map>) request.getAttribute("workInfoList2");   // 고객유형
@SuppressWarnings("unchecked") List<Map> branchList         = (List<Map>) request.getAttribute("branchList");      // 사업장
%>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle"> 진열 관리<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmMngt">
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>
        	권역(AND)
        	<p><label><input id="chkAll" type="checkbox" style="vertical-align: middle;"/> 전체선택</label></p>
        </th>
        <td id="tabDeli">
        <% 
            int chkTmpCnt = 0; 
            for (CodesDto code : deliAreaList) { 
        %>
            <label class="wp100">
				<input type="checkbox" value="<%=code.getCodeVal1()%>"  style="vertical-align: middle;" id="deliVal_<%=chkTmpCnt%>" name="deliVal"/> <%=code.getCodeNm1()%>
            </label>
        <% 
				chkTmpCnt++;
            } 
        %>
        </td>
      </tr>
      <tr>
        <th>
        	고객유형(AND)
        </th>
        <td id="tabDeli2">
            <% 
				chkTmpCnt = 0;
                for (Map code : workInfoList1) { 
            %>
            <label class="wp100">
                <input type="checkbox" value="<%=code.get("WORKID")%>"  style="vertical-align: bottom;" id="workVal_<%=chkTmpCnt%>" name="workVal"/> <%=code.get("WORKNM")%>
            </label>
            <% 
                    chkTmpCnt++;
                } 
            %>
        </td>
      </tr>
      <tr>
        <th>사업장(OR)<br/><button id="btnAddBranch" type="button" class="btn btn-primary btn-xs">추가</button></th>
        <td><table id="tabBranch" width="100%">
          <tr>
            <th colspan="2">사업장</th>
          </tr>
            <tr id="noWork2" >
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
    $("#productPopDispMngt").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPopDispMngt').html('');
        $('#productPopDispMngt').jqmHide();
    });
    $('#chkAll').click(function () {
    	$('#tabDeli input[type=checkbox]').attr('checked', this.checked);
    });
    $('#chkAll2').click(function () {
    	$('#tabDeli2 input[type=checkbox]').attr('checked', this.checked);
    });
    $('#btnAddBranch').click(function () {
        fnBuyborgDialog("BCH", "1", "", "fnCallBackClient"); 
    });
    $('#btnSave').click(function () {
		var deliValArr = new Array();
		var workValArr = new Array();
		var branchValArr = new Array();
        var gin_ven_arr = new Array();
        $('input[name=deliVal]:checked').each(function(){
            deliValArr[deliValArr.length] = $(this).val()
        });
        $('input[name=workVal]:checked').each(function(){
            workValArr[workValArr.length] = $(this).val()
        });
    	if (deliValArr.length > 0 && workValArr.length == 0) {
    		alert('권역을 하나 이상 선택하시면  고객유형을 하나 이상 선택하셔야 합니다.');
            return;
    	}
        if (deliValArr.length == 0 && workValArr.length > 0) {
            alert('고객유형을 하나 이상 선택하시면  권역을 하나 이상 선택하셔야 합니다.');
            return;
        }
        $('input[name=branchid]').each(function(){
            branchValArr[branchValArr.length] = $(this).val()
        });
        var rowCnt = $("#list").getGridParam('reccount');
        var chktempcnt = 0;
        var listDataIds = $("#list").getDataIDs();
        for(var i = 0; i < rowCnt; i++){
            var rowid = listDataIds[i];
            if($("#isCheck_"+rowid).attr("checked")) {
            	chktempcnt++;
                var selrowContent = $("#list").jqGrid("getRowData", rowid);
            	gin_ven_arr[gin_ven_arr.length] = selrowContent.GOOD_IDEN_NUMB+"_"+selrowContent.VENDORID;
            }
        }
        if(chktempcnt == 0){
			alert("상품을 선택하여 주십시오.");
            return;
        }
        if (!confirm("진열정보를 저장하시겠습니까?")) return;
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveDispMngt.sys'
        	,{
        		deliValArr:deliValArr,
        		workValArr:workValArr,
        		branchValArr:branchValArr,
        		gin_ven_arr:gin_ven_arr
        	}, 
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
            	  try{
                      $('#productPopDispMngt').html('');
                      $('#productPopDispMngt').jqmHide();  
                      alert('처리하였습니다.');
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
function fnDelBranch(obj) {
    var tr = $(obj).closest('tr');
    var good_display_branch_id = tr.find('input[name=good_display_branch_id]');
    if (good_display_branch_id.val() == '') {
        tr.remove();
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
   '<td width="30" align="right"><input type="hidden" name="good_display_branch_id"/><input type="hidden" name="branchid" value="'+branchId+'"/><button onclick="fnDelBranch(this)" type="button" class="btn btn-default btn-xs">삭제</button></td></tr>';
   $('#noWork2').hide();
   $('#tabBranch').append(tr);
}
</script>