<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
    //그리드의 width와 Height을 정의
    String listHeight = "$(window).height()-310 + Number(gridHeightResizePlus)";
//     String listWidth = "$(window).width()-463 + Number(gridWidthResizePlus)";
    String listWidth = "1087";

    @SuppressWarnings("unchecked")
    //화면권한가져오기(필수)
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Global.css">
<link rel="stylesheet" type="text/css" href="<%=Constances.SYSTEM_JSCSS_URL %>/css/Default.css">
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
    <tr>
        <td colspan="2" bgcolor="#FFFFFF">
            <!-- 타이틀 -->
            <table width="1500px"  border="0" cellspacing="0" cellpadding="0">
                <tr valign="top">
                    <td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
                    <td class='ptitle'>Main 전시 상품관리</td> 
                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
                        <button id='addButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-plus"></i> 추가</button>
                        <button id='delButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-times"></i> 삭제</button>
                    </td>
                </tr>
            </table>
        </td>
     </tr>
     <tr>
     	<td>   
            <table border="0" cellspacing="0" cellpadding="0" style="float:left;margin-right:10px">
                <tr>
                    <td valign="top">
                        <table id="list1"></table>
                        <div id="pager1"></div>
                    </td>
                </tr>
            </table>
        </td>
        <td>
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td valign="top">
                        <table id="list2"></table>
                        <div id="pager2"></div>
                    </td>
                </tr>
            </table>
            <div id="dialog" title="Feature not supported" style="display:none;">
                <p>That feature is not supported.</p>
            </div>
            
        </td>
    </tr>
</table>
<form id="frmDel">
<input type="hidden" name="oper" value="del"/>
<input type="hidden" id="workid" name="workid"/>
<input type="hidden" id="good_iden_numb" name="good_iden_numb"/>
</form>

<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
    <p>처리할 데이터를 선택 하십시오!</p>
</div>
<style type="text/css">
.jqmWindow {
    display: none;
    position: absolute;
    top: 30%;
    left: 30%;
    width: 600px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}
.jqmWindow1 {
    display: none;
    position: absolute;
    top: 5%;
    left: 30%;
    width: 850px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}
.jqmOverlay { background-color: #000; }
</style>
<div class="jqmWindow1" id="productPop" style="top:50%; left:50%;"></div>
<script type="text/javascript">
$(function(){
    $.ajaxSetup({cache:false});
    $('#productPop').jqm();
    fnGridInit();
    $('#addButton').click(function () {
      var rowid = $('#list1').jqGrid('getGridParam','selrow');
      if (rowid < 1) {
        alert('선택된 고객유형이 없습니다. 고객유형 선택후 이용하시기 바랍니다.');
        return false;
      }

      var row = $('#list1').jqGrid('getRowData',rowid);
//       $('#productPop').html('')
      $('#productPop').css({'top':'20%','left':'20%'}).html('')
      .load('/menu/product/product/popProductSearch2.sys?workid='+row.WORKID)
      .jqmShow();
    });
    $('#delButton').click(function () {
      var ids = $("#list2").jqGrid('getGridParam','selarrrow');
      if (ids.length == 0) {
          alert('선택한 상품이 없습니다.');
          return;
      }
      $('#frmDel #good_iden_numb').val(ids);
      $.post('/product/deleteMainDispGood/save.sys', $('#frmDel').serialize(), function () {
	      for (var i=ids.length;i>=0;i--) {
	        $("#list2").delRowData(ids[i]);
	      }
      });
    });
    
});
function numberWithCommas(x) {
  if (x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  } else {
    return '0';
  }
}
//그리드 초기화
function fnGridInit() {
    $("#list1").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectWorkInfoList3/list.sys',
        datatype: 'json',
        mtype: 'POST',
        colNames:['고객유형','담당자명','등록개수',''],
        colModel:[
            {name:'WORKNM',width:200},//고객유형
            {name:'USERNM',width:80,align:'center'},//구분
            {name:'PROD_CNT',width:50,align:'right'},//등록개수
            {name:'WORKID',hidden:true}//WORKID
        ],
        rowNum:30, rownumbers:true, rowList:[30,50,100,200], pager: '#pager1',
        height:<%=listHeight%>, width:400, caption:'고객유형',
        sortname: 'WORKNM', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
         onSelectRow: function(rowid, status, e) {
            var selrowContent = $("#list1").jqGrid('getRowData',rowid);
            $('#frmDel #workid').val(selrowContent.WORKID);
            $("#list2").jqGrid("setGridParam", {datatype:'json',"postData":{"WORKID":selrowContent.WORKID}});
            $("#list2").trigger("reloadGrid");
        },
        loadComplete: function() {
          var rowCnt = $(this).getGridParam('reccount');
          if(rowCnt>0) {
            var top_rowid = $(this).getDataIDs()[0];
            $(this).setSelection(top_rowid);
          } 
        }
    })
    .jqGrid("setLabel", "rn", "순번");
    
    $("#list2").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectMainDispGoodList/list.sys',
        datatype: 'local',
        mtype: 'POST',
        colNames:['상품코드','상품명','규격','배너','','','','','판매가','','','매입가',''],
        colModel:[
            {name:'GOOD_IDEN_NUMB',width:80,align:'center',key:true},//상품코드
            {name:'GOOD_NAME',width:160},//상품명
            {name:'GOOD_SPEC',width:130},//규격
            {name:'BANNER_ID',width:300},//배너
            {name:'BANNER_FILE',hidden:true},
            {name:'BANNER_PATH',hidden:true},
            {name:'SELL_PRICE1',hidden:true},//판매가1
            {name:'SELL_PRICE2',hidden:true},//판매가2
            {name:'SELL_PRICE',width:100,formatter:function (v, o, r) { return numberWithCommas(r.SELL_PRICE1)+'~'+numberWithCommas(r.SELL_PRICE2); }},
            {name:'SALE_UNIT_PRIC1',hidden:true},//매입가1
            {name:'SALE_UNIT_PRIC2',hidden:true},//매입가2
            {name:'SALE_UNIT_PRIC',width:100,formatter:function (v, o, r) { return numberWithCommas(r.SALE_UNIT_PRIC1)+'~'+numberWithCommas(r.SALE_UNIT_PRIC2); }},
            {name:'VENDORID',hidden:true}
        ],
        postData: $('#frmSearch').serializeObject(),
        rowNum:30, rowList:[30,50,100,200], pager: '#pager2',
        height:<%=listHeight%>,width:<%=listWidth%>, caption:'Main 전시상품',
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', multiselect: true,
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
        loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
            $(this).setCell(rowid,'GOOD_IDEN_NUMB','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $("#list2").jqGrid('getRowData',rowid);
            var cm = $("#list2").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
            if(colName != undefined &&colName['name']=="GOOD_IDEN_NUMB") {
                var url = '/product/popProductAdm.sys?good_iden_numb=' + selrowContent.GOOD_IDEN_NUMB + '&vendorid=' + selrowContent.VENDORID;
                var win = window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
                win.focus();
            }
        },
        loadComplete:function() {
        	var rowCnt = $("#list2").getGridParam('reccount');
            for(var idx=0; idx<rowCnt; idx++) {
            	var rowid = $("#list2").getDataIDs()[idx];
                $("#list2").restoreRow(rowid);
                var selrowContent = $("#list2").jqGrid('getRowData',rowid);
                // img 화면 로드 
                var imgTag = ""; 
                if($.trim(selrowContent.BANNER_ID) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys?attachFilePath="+selrowContent.BANNER_PATH+"' ";   
                else imgTag = "<img src='/img/system/imageResize/prod_img_50.gif' ";
                imgTag += "style='max-width:200px;height:35px;' good='"+selrowContent.GOOD_IDEN_NUMB+"'/>";
                imgTag += "&nbsp;<div style='float:right;margin-top:4px'><button type='button' class='btn btn-primary btn-xs btnRegFile'>등록</button> <button type='button' class='btn btn-default btn-xs btnDelFile'>삭제</button></div>";
                $('#list2').jqGrid('setRowData',rowid,{BANNER_ID:imgTag});
            }
		    $('#list2 .btnRegFile').click(function() {
		    	bannerImg = $(this).parent().prev();
		        fnUploadDialog('배너추가', '', "fnCallBack"); 
		    });
            $('#list2 .btnDelFile').click(function() {
            	if (!confirm('정말로 삭제하시겠습니까?')) return;
            	bannerImg = $(this).parent().prev();
            	var good_iden_numb = bannerImg.attr('good');
			    var workid = $('#frmDel #workid').val();
			    $.post("/product/updateMainDispGood/save.sys",'oper=edit&good_iden_numb='+good_iden_numb+'&workid='+workid+'&banner_id=',function(arg) {
			            bannerImg.attr('src', '/img/system/imageResize/prod_img_50.gif');            
			        }
			    );
                
            });
        }
    });
}
var bannerImg = null;
// 파일 첨부 
function fnCallBack(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
	var good_iden_numb = bannerImg.attr('good');
	var workid = $('#frmDel #workid').val();
    $.post("/product/updateMainDispGood/save.sys",'oper=edit&good_iden_numb='+good_iden_numb+'&workid='+workid+'&banner_id='+rtn_attach_seq,function(arg) {
            bannerImg.attr('src', "<%=Constances.SYSTEM_CONTEXT_PATH %>/common/attachFileDownload.sys?attachFilePath="+rtn_attach_file_path);            
        }
    );
}
// Resizing
$(window).bind('resize', function() { 
    $("#list1").setGridHeight(<%=listHeight %>);
    $("#list2").setGridHeight(<%=listHeight %>);
    $("#list2").setGridWidth(<%=listWidth %>);
}).trigger('resize');
/**
 * 카테고리 팝업 호출  
 */
function fnCategoryPopOpen(){
     fnSearchStandardCategoryInfo("1", "fnCallBackStandardCategoryChoice"); 
}
/**
 * 카테고리 선택 콜백   
 */
function fnCallBackStandardCategoryChoice(categortId , categortName , categortFullName) {
    var msg = ""; 
    $('#srcCateId').val(categortId); 
    $('#srcMajoCodeName').val(categortFullName); 
}  
function selectProductManager() {
    //상품담당자 셀렉트박스
    //B2B권한
    $.post(
        "/product/selectProductManager/list.sys",
        {},
        function(arg){
            var productManagetList = eval('('+arg+')').list;
            for(var i=0; i<productManagetList.length; i++){
                $("#srcProductManager").append("<option value='"+productManagetList[i].USERID+"'>"+productManagetList[i].USERNM+"</option>");
            }
        }
    );
}
/**
 * 공급사 검색 
 */
function fnVendorSearchOpenPop(){
    var vendorNm = $("#srcVendorName").val();   
    fnVendorDialog(vendorNm, "fnCallBackVendor");
}
/**
 * 공급사 선택 콜백 
 */
function fnCallBackVendor(vendorId, vendorNm, areaType){
    $("#srcVendorId").val(vendorId);
    $("#srcVendorName").val(vendorNm);
}
</script>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
</body>
</html>