<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">재고 이력조회<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
<form id="frmStock">
<input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
<input type="hidden" name="vendorid" value="${param.vendorid}"/>
</form>
  <div class="popcont">
    <div class="GridList">
        <table id="listStock"></table>
        <div id="pagerStock"></div>
    </div>
    <div class="Ac mgt_10">
       <button type="button" class="btn btn-default btn-sm jqmClose"><i class="fa fa-times"></i> 닫기</button>
    </div>
  </div>
</div>
<script type="text/javascript">
$(function() {
    fnGridInit();
    $("#productPop").jqDrag('#userDialogHandle');
    $('.jqmClose').click(function (e) {
        $('#productPop').html('');
        $('#productPop').jqmHide();
    });
});
//그리드 초기화
function fnGridInit() {
    $("#listStock").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectStockHistList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['증감','재고','처리자','주문번호','처리일시','변경사유'],
        colModel:[
            {name:'STOCK_VARIATION',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//증감
            {name:'STOCK',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//재고
            {name:'USER_NM',width:80,align:'center',sortable:false},//처리자
            {name:'ORDER_IDEN_NUMB',width:80,sortable:false},//주문번호
            {name:'INSERT_DATE',width:120,align:'center',sortable:false},//처리일시
            {name:'CHG_REASON',width:130,sortable:false}//변경사유
        ],
        postData: $('#frmStock').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pagerStock',
        height:200,width:568,
        sortname: 'STOCK_CHG_HIST_ID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        loadError : function(xhr, st, str){ $("#listStock").html(xhr.responseText); }
    })
    .jqGrid("setLabel", "rn", "순번");
}
</script>