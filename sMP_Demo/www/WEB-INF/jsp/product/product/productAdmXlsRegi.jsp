<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List" %>

<%
    @SuppressWarnings("unchecked")
    List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");           //화면권한가져오기(필수)
    String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
    
    //String listHeight = "$(window).height()-400 + Number(gridHeightResizePlus)";
//     String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
    String listWidth = "1500";
    String listHeight = "$(window).height()-270 + Number(gridHeightResizePlus)";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Insert title here</title>

<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<!--------------------------- Modal Dialog Start --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css">
.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 600px;
    
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}

.jqmOverlay { background-color: #000; }

* html .jqmWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<!--------------------------- Modal Dialog End --------------------------->

<!-- file Upload 스크립트 -->
<script type="text/javascript">
$(function(){
    var btnUpload=$('#importButton');
    var status=$('#status');
    new AjaxUpload(btnUpload, {
        action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/productExcelUpload.sys',
        name: 'excelFile',
        data: {},
        onSubmit: function(file, ext){
            if (! (ext && /^(xls|xlsx)$/.test(ext))){
                status.text("엑셀파일만 등록 가능합니다."); // extension is not allowed 
                return false;
            }
            if(!confirm("작성한 엑셀정보을 등록하시겠습니까?")) return false;
            status.text('Uploading...');
        },
        onComplete: function(file, response){
            status.text('');
            $('#dialogPop').jqmHide();
            fnTransResult(response);
            $('#list').jqGrid('clearGridData');
            var list = eval('(' + response + ')').list;
            for(var idx = 0 ; idx < list.length ; idx ++){
                var insObs = list[idx];
                jQuery("#list").jqGrid('addRowData',idx+1,insObs);
            }
        }
    });
    // Dialog Button Event
    $('#dialogPop').jqm();  //Dialog 초기화
    $("#uploadButton2").click(function(){
        $('#dialogPop').jqmShow();
    });
    $("#closeButton").click(function(){ //Dialog 닫기
        $('#dialogPop').jqmHide();
    });
    $('#dialogPop').jqm().jqDrag('#dialogHandle'); 
});
$(window).bind('resize', function() {
   $("#list").setGridHeight(<%=listHeight %>);
   $("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
	var jq = jQuery;                            // jQuery  설정
	$(document).ready(function() {
	    $("#excelButton").click(function(){ exportExcel();});
	    $("#dispAllButton").click(function(){ fnMoveGoodDispUpload();});
	    $("#noneDispButton").click(function(){ fnMoveNoneGoodDispUpload();});
	    fnInitGrid();
	});
	var fnInitGrid = function () {
	    jq("#list").jqGrid({
	        datatype: "local",
//	         datatype:'json',
//	         mtype:'POST',
	        colNames:[
				'상품코드',		'*카테고리코드',	'*상품명',		'*상품실적년',	'*신규상품',
				'*상품규격',		'*과세구분',		'*상품담당자',	'*주문단위',		'*상품구분',
				'*공급사노출',	'*물량배분여부',	'*재고관리',		'*추가상품',		'*운영사이미지관리',
				'*공급사코드',	'사용여부',		'*판매가',		'*매입가',		'*납품소요일',
				'*최소주문수량',	'*물량배분율',	'*제조사',		'*재고수량',		'*상품우선순위',
				'정합성',		'에러'
			],
	        colModel:[
	                  {name: 'good_iden_numb'      ,index:'good_iden_numb'      , width:100 ,sortable:false }     //  상품코드	       
	                  ,{name:'cate_cd'             ,index:'cate_cd'             , width:100 ,sortable:false }     //  카테고리코드	        
                      ,{name:'good_name'           ,index:'good_name'           , width:100 ,sortable:false }     //  상품명            
	                  ,{name:'good_reg_year'       ,index:'good_reg_year'       , width:100 ,sortable:false }     //  상품실적년	    
                      ,{name:'new_busi'            ,index:'new_busi'            , width:100 ,sortable:false }     //  신규상품
                      
                      ,{name:'good_spec'           ,index:'good_spec'           , width:100 ,sortable:false }     //  상품규격     
	                  ,{name:'vtax_clas_code'      ,index:'vtax_clas_code'      , width:100 ,sortable:false }     //  과세구분	       
                      ,{name:'product_manager'     ,index:'product_manager'     , width:100 ,sortable:false }     //  상품담당자
	                  ,{name:'order_unit'          ,index:'order_unit'          , width:100 ,sortable:false }     //  주문단위
	                  ,{name:'good_type'           ,index:'good_type'           , width:100 ,sortable:false }     //  상품구분
	                  
	                  ,{name:'vendor_expose'       ,index:'vendor_expose'       , width:100 ,sortable:false }     //  공급사노출	     
	                  ,{name:'isdistribute'        ,index:'isdistribute'        , width:100 ,sortable:false }     //  물량배분여부	    
	                  ,{name:'stock_mngt'          ,index:'stock_mngt'          , width:100 ,sortable:false }     //  재고관리     
                      ,{name:'add_good'            ,index:'add_good'            , width:100 ,sortable:false }     //  추가상품      
                      ,{name:'skts_img'            ,index:'skts_img'            , width:100 ,sortable:false }     //  SKTS이미지관리
                      
	                  ,{name:'vendorid'            ,index:'vendorid'            , width:100 ,sortable:false }     //  공급사코드	     
	                  ,{name:'isUse'               ,index:'isUse'               , width:100 ,sortable:false }     //  사용여부	     
	                  ,{name:'sell_price'          ,index:'sell_price'          , width:100 ,sortable:false }     //  판매가	    
                      ,{name:'sale_unit_pric'      ,index:'sale_unit_pric'      , width:100 ,sortable:false }     //  매입가         
                      ,{name:'deli_mini_day'       ,index:'deli_mini_day'       , width:100 ,sortable:false }     //  납품소요일
                      
                      ,{name:'deli_mini_quan'      ,index:'deli_mini_quan'      , width:100 ,sortable:false }     //  최소주문수량        
                      ,{name:'distri_rate'         ,index:'distri_rate'         , width:100 ,sortable:false }     //  물량배분율   
                      ,{name:'make_comp_name'      ,index:'make_comp_name'      , width:100 ,sortable:false }     //  제조사        	       
	                  ,{name:'good_inventory_cnt'  ,index:'good_inventory_cnt'  , width:100 ,sortable:false }     //  재고수량	     
                      ,{name:'vendor_priority'     ,index:'vendor_priority'     , width:100 ,sortable:false }     //  상품우선순위
                      
	                  ,{name:'valRlt'              ,index:'valRlt'              , width:100 ,sortable:false }     //  정합성
	                  ,{name:'rtnError'            ,index:'rtnError'            , width:100 ,sortable:false }     //  Error
	        ],
	        postData: new Object() ,
	        rowNum:0,rownumbers:false,
	        height:<%=listHeight%>,width:<%=listWidth%>,
	        sortname:'borgNms',sortorder:'asc', 
	        viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
	        loadComplete:function(){},
	        onSelectRow:function(rowid,iRow,iCol,e) {},
	        ondblClickRow:function(rowid,iRow,iCol,e) {},
	        onCellSelect:function(rowid,iCol,cellcontent,target) {},
	        loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
	        jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	    });	    
	};

// 엑셀 다운로드 
function exportExcel() {
	var colLabels = [
		'상품코드',		'*카테고리코드',	'*상품명',		'*상품실적년',	'*신규상품',
		'*상품규격',		'*과세구분',		'*상품담당자',	'*주문단위',		'*상품구분',
		'*공급사노출',	'*물량배분여부',	'*재고관리',		'*추가상품',		'*SKTS이미지관리',
		'*공급사코드',	'사용여부',		'*판매가',		'*매입가',		'*납품소요일',
		'*최소주문수량',	'*물량배분율',	'*제조사',		'*재고수량',		'*상품우선순위',
		'정합성',		'에러'
	];	//출력컬럼명
	var colIds = [
		'good_iden_numb',  'cate_cd',        'good_name',       'good_reg_year',      'new_busi',
		'good_spec',       'vtax_clas_code', 'product_manager', 'order_unit',         'good_type',
		'vendor_expose',   'isdistribute',   'stock_mngt',      'add_good',           'skts_img',
		'vendorid',        'isUse',          'sell_price',      'sale_unit_pric',     'deli_mini_day',
		'deli_mini_quan',  'distri_rate',    'make_comp_name',  'good_inventory_cnt', 'vendor_priority',
		'valRlt',          'rtnError'
	];	//출력컬럼ID
	var numColIds = [];	//숫자표현ID
	var sheetTitle = "일괄상품등록정보";	//sheet 타이틀
	var excelFileName = "uploadGoodList";	//file명
	
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
//상품진열일괄등록
function fnMoveGoodDispUpload(){
    $('#frm').attr('action','/productManage/productDispExcelRegi.sys?_menuId=<%=_menuId%>');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();	
}
//상품진열일괄종료
function fnMoveNoneGoodDispUpload(){
    $('#frm').attr('action','/productManage/productNoneDispAdmXls.sys?_menuId=<%=_menuId%>');
    $('#frm').attr('Target','_self');
    $('#frm').attr('method','post');
    $('#frm').submit();	
}
</script>
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
	<form id="frm">
		<input type="hidden" id="_menuId" name="_menuId" value="<%=_menuId%>"/>
	</form>
    <table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0" bgcolor="white">
        <tr>
            <td>
                <!-- 타이틀 시작 -->
                <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                    <tr valign="top">
                        <td width="20" valign="middle">
                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
                        </td>
                        <td height="29" class='ptitle'>상품일괄등록</td>
			            <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
			                <button id='excelButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
			                <button id='uploadButton2' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 상품엑셀업로드</button>
			            </td>   
                    </tr>
                </table>
                <!-- 타이틀 끝 -->
            </td>
        </tr>
        <tr>
            <td>
                <!-- 컨텐츠 시작 -->
                <table width="1500px" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="6" class="table_top_line"></td>
                    </tr>
                </table>
                <!-- 컨텐츠 끝 -->
            </td>
        </tr>
        <tr>
            <td height="5"></td>
        </tr>
        <tr>
            <td style="height: 4px;"></td>
        </tr>
        <tr>
            <td valign="top">
                <div id="jqgrid">
                    <table id="list"></table>
                </div>
            </td>
        </tr>
       
    </table>
    <!-------------------------------- Dialog Div Start -------------------------------->
    <div class="jqmWindow" id="dialogPop">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <div id="dialogHandle">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
                            <tr>
                                <td width="21">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_left.gif" width="21" height="47" />
                                </td>
                                <td width="22">
                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_bullet.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                </td>
                                <td class="popup_title">상품정보 일괄업로드</td>
                                <td width="22" align="right">
                                    <a href="#" class="jqmClose">
                                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Close.gif" width="14" height="13" style="margin-bottom: 5px;" />
                                    </a>
                                </td>
                                <td width="10" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_right.gif');">&nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" />
                            </td>
                        </tr>
                        <tr>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
                            <td bgcolor="#FFFFFF">
                                <!-- 타이틀 -->
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td width="20">
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet01.gif" align="bottom" />
                                        </td>
                                        <td class='ptitle'>사용방법</td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr valign="top">
                                        <td height="23px" class="table_td_contents">1. 컬럼에 *로 표기된 값은 필수 입니다.</td>
                                    </tr>
                                    <tr valign="top">
                                        <td height="23px" class="table_td_contents">2. 샘플파일 두번째 Sheet를 확인하시면 사용하고 있는 code 정보를 열람 하실수 있습니다. .</td>
                                    </tr>
                                    <tr valign="top">
                                        <td height="23px" class="table_td_contents">
                                            <a href="<%=Constances.SYSTEM_IMAGE_URL%>/upload/sample/productExcellUploadSample.xlsx">샘플파일 다운로드</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr valign="top">
                                        <td>
                                            <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/member_excel.gif" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                </table>
                                <span id="status" style="color: #FF0000"></span>
                                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td align="center">
									        <button id="importButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"></i> 엑셀업로드</button>
									        <button id="closeButton" type="button" class="btn btn-default btn-sm"><i class="fa fa-times"></i> 닫기</button>  
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="20" height="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20" />
                            </td>
                            <td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
                            <td width="20">
                                <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" />
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</body>
</html>