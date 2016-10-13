<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">옵션상품 추가<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmProduct">
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
      <col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>상품명</th>
        <td><input name="srcGoodName" type="text" style="width:200px" /></td>
        <th>상품코드</th>
        <td><input name="srcGoodIdenNumb" type="text" style="width:200px" /></td>
      </tr>
    </table>
    </form>
    <div class="Ar mgt_5 mgb_10"><a href="#" id="srcButton"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_tablesearch.gif" /></a></div>
    <div class="GridList">
        <table id="listProduct"></table>
        <div id="pagerProduct"></div>
    </div>
    <div class="Ac mgt_10">
       <button id="selButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-check"></i> 선택</button>
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
	fnGridInit();
    $('#srcButton').click(function (e) {
        fnSearch();
    });
    $('#selButton').click(function (e) {
        var ids = $("#listProduct").jqGrid('getGridParam','selarrrow');
        if (ids.length == 0) {
        	alert('선택한 상품이 없습니다.');
        	return;
        }
        var newRowId = $("#list5").getDataIDs().length+1;
        var params = "repre_good_iden_numb=${param.good_iden_numb}";
        for (var id in ids) {
            var data = $("#listProduct").jqGrid('getRowData',ids[id]);
            var pims = $('#' + ids[id] + '_PIMS').val();
            if (pims == '') {
            	alert('단가코드를 입력해주세요.');
            	$('#' + ids[id] + '_PIMS').focus();
            	return;
            }
            if(isNaN(pims)) {
            	alert('단가코드를 숫자로만 입력해주세요.');
                $('#' + ids[id] + '_PIMS').focus();
                return;
            }
            params = params + "&good_iden_numb=" + data.GOOD_IDEN_NUMB + "&pims=" + pims;
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveOptions.sys', params,
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  for (var id in ids) {
                      var data = $("#listProduct").jqGrid('getRowData',ids[id]);
			          var pims = $('#' + ids[id] + '_PIMS').val();
                      $('#optOption').append("<option value='"+data.GOOD_IDEN_NUMB+"'>"+data.GOOD_SPEC+"</option>");
                      var order = parseInt(newRowId,10) + parseInt(id,10);
                      data.PIMS = pims;
                      reloadList5();
//                       $("#list5").addRowData(order, data);
                  }
//                   $('#list6').trigger("reloadGrid");
				reloadList6();
                  $('.jqmClose').click();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('#frmProduct').search();
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});
//그리드 초기화
function fnGridInit() {
    $("#listProduct").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectPopOptionProductList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품코드','상품명','상품규격','단가코드'],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:80,align:'center',sortable:false},//상품코드
            {name:'GOOD_NAME',width:160,sortable:false},//상품명
            {name:'GOOD_SPEC',width:200,sortable:false},//상품규격
            {name:'PIMS',width:60,sortable:false,editable:true}
        ],
        postData: $('#frmProduct').serializeObject(),
        rowNum:30, rownumbers:false, rowList:[30,50,100,200], pager: '#pagerProduct',
        height:360,width:568,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', multiselect: true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        loadError : function(xhr, st, str){ $("#listProduct").html(xhr.responseText); },
        onSelectRow: function(id, status) {
          if (status) {
	       $('#listProduct').editRow(id, status);
          } else {
           $('#listProduct').restoreRow(id, status);	  
          }
	    }
        
    });
}
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
    $("#listProduct")
    .jqGrid("setGridParam", {'page':1,'postData':$('#frmProduct').serializeObject()})
    .trigger("reloadGrid");
}
/**
 * 카테고리 팝업 호출  
 */
function fnCategoryPopOpen2(){
     fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice2"); 
}
/**
 * 카테고리 선택 콜백   
 */
function fnCallBackStandardCategoryChoice2(categortId , categortName , categortFullName) {
    var msg = ""; 
    $('#srcCateId').val(categortId); 
    $('#srcCateNm').val(categortFullName); 
}
</script>