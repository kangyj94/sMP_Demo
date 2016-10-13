﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>
<div id="divPopup" style="width:600px;">
<h1 id="userDialogHandle">상품검색<a href="#" class="jqmClose"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/btn_close.png"></a></h1>
  <div class="popcont">
    <form id="frmProduct">
    <input type="hidden" name="workid" value="${param.workid}"/>
    <input type="hidden" id="good_iden_numb" name="good_iden_numb"/>
    <table class="InputTable">
    <colgroup>
    	<col width="120px" />
      <col width="auto" />
      <col width="120px" />
      <col width="auto" />
    </colgroup>
      <tr>
        <th>상품명</th>
        <td><input name="srcGoodName" type="text" style="width:150px" /></td>
        <th>상품규격</th>
        <td><input name="srcGoodSpecDesc" type="text" style="width:150px" /></td>
      </tr>
      <tr>
        <th>카테고리</th>
        <td colspan="3">
            <input id="srcCateNm" name="srcCateNm" type="text" style="width:250px" />
            <input id="srcCateId" name="srcCateId" type="hidden" />
            <img onclick="fnCategoryPopOpen2()" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_search.gif" width="20" height="20" /> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/contents/icon_edit.gif" width="20" height="20" />
        </td>
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
        $('#frmProduct #good_iden_numb').val(ids.join(','));
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/product/saveMainDispGood.sys', $('#frmProduct').serialize(), function () {
          $("#list2").trigger("reloadGrid");
          $('.jqmClose').click();
        });
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
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectPopProductList2/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['상품코드','상품명','상품규격','','','판매가','','','매입가'],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:80,align:'center',sortable:false,key:true},//상품코드
            {name:'GOOD_NAME',width:140,sortable:false},//상품명
            {name:'GOOD_SPEC',width:78,sortable:false},//상품규격
            {name:'SELL_PRICE1',hidden:true},//판매가1
            {name:'SELL_PRICE2',hidden:true},//판매가2
            {name:'SELL_PRICE',width:100,formatter:function (v, o, r) { return numberWithCommas(r.SELL_PRICE1)+'~'+numberWithCommas(r.SELL_PRICE2); }},
            {name:'SALE_UNIT_PRIC1',hidden:true},//매입가1
            {name:'SALE_UNIT_PRIC2',hidden:true},//매입가2
            {name:'SALE_UNIT_PRIC',width:100,formatter:function (v, o, r) { return numberWithCommas(r.SALE_UNIT_PRIC1)+'~'+numberWithCommas(r.SALE_UNIT_PRIC2); }}
        ],
        postData: $('#frmProduct').serializeObject(),
        rowNum:30, rownumbers:false, rowList:[30,50,100,200], pager: '#pagerProduct',
        height:200,width:568,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', multiselect: true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        loadError : function(xhr, st, str){ $("#listProduct").html(xhr.responseText); }
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