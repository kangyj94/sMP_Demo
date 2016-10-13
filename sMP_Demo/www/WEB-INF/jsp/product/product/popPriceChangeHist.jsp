<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">${param.sell_sale_type eq 'SALE' ? '판매가':'매입가'} 변경 이력조회<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
<form id="frmPrice">
<input type="hidden" name="good_iden_numb" value="${param.good_iden_numb}"/>
<input type="hidden" name="vendorid" value="${param.vendorid}"/>
<input type="hidden" name="sell_sale_type" value="${param.sell_sale_type}"/>
</form>
  <div class="popcont">
    <div class="GridList">
        <table id="listPrice"></table>
        <div id="pagerPrice"></div>
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
    $("#listPrice").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectPriceHistList/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['판매가','매입가','처리자','처리일시','변경사유'],
        colModel:[
            {name:'SELL_PRICE',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//판매가
            {name:'SALE_UNIT_PRIC',width:48,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },sortable:false},//매입가
            {name:'USER_NM',width:80,align:'center',sortable:false},//처리자
            {name:'INSERT_DATE',width:120,align:'center',sortable:false},//처리일시
            {name:'CHG_REASON',width:200,sortable:false}//변경사유
        ],
        postData: $('#frmPrice').serializeObject(),
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pagerPrice',
        height:200,width:568,
        sortname: 'PRICE_CHG_HIST_ID', sortorder: 'desc',
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        loadError : function(xhr, st, str){ $("#listPrice").html(xhr.responseText); }
    })
    .jqGrid("setLabel", "rn", "순번");
}
</script>