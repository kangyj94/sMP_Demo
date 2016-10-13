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
    String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
    String listHeight = "$(window).height()-170 + Number(gridHeightResizePlus)";
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
        action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/productManage/productDispExcelUpload.sys',
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
		$("#prodAllButton").click(function(){ fnMoveGoodUpload();});
		$("#noneDispButton").click(function(){ fnMoveNoneGoodDispUpload();});
		$("#excelButton").click(function()			{ exportExcel(); 																			});
		fnInitGrid();
	});
	var fnInitGrid = function () {
		jq("#list").jqGrid({
			datatype: "local",
// 			datatype:'json',
// 			mtype:'POST',
			colNames:[  '*상품코드' ,'*상품명' ,'*공급사코드' ,'*공급사명' ,'*권역코드' ,'*권역명' ,'판매가' ,'정합성','에러'],
			colModel:[
				{name: 'good_iden_numb', index:'good_iden_numb', width:100 ,sortable:false, align:'center' },
				{name: 'good_name', index:'good_name'      , width:150 ,sortable:false },
				{name:'vendorcd', index:'vendorcd', width:100 ,sortable:false },
				{name:'vendornm', index:'vendornm', width:100 ,sortable:false },
				{name:'areatypecd', index:'areatypecd', width:70 ,sortable:false, align:'center' },
				{name:'areatypenm', index:'areatypenm', width:70 ,sortable:false, align:'center' },
				{name:'sell_price',index:'sell_price',width:80,align:"right",search:false,sortable:false, editable:false,
					sorttype:'integer',formatter:'integer',
					formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},
				{name:'valRlt', index:'valRlt', width:200 ,sortable:false },
				{name:'rtnError', index:'rtnError', width:200 ,sortable:false }
			],
			postData: new Object() ,
			rowNum:0,rownumbers:false,
			height:<%=listHeight%>,width:<%=listWidth%>,
			sortname:'borgNms',sortorder:'asc',
			caption:"상품진열 일괄등록 정보", 
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
	var colLabels = ['*상품코드','*상품명','*공급사코드','*공급사명','*권역코드','*권역명','판매가','에러'];	//출력컬럼명
	var colIds = ['good_iden_numb','good_name','vendorcd','vendornm','areatypecd','areatypenm','sell_price','rtnError'];	//출력컬럼ID
	var numColIds = ['sell_price'];	//숫자표현ID
	var sheetTitle = "상품진열 일괄등록";	//sheet 타이틀
	var excelFileName = "uploadGoodDispList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}
//상품일괄등록
function fnMoveGoodUpload(){
    $('#frm').attr('action','/productManage/productExcelRegi.sys?_menuId=<%=_menuId%>');
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
 
<body>
<form id="frm">
<input type="hidden" id="_menuId" name="_menuId" value="<%=_menuId%>"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>상품권역 일괄등록</td>
				</tr>
			</table>
			<!-- 타이틀 끝 -->
		</td>
	</tr>
	<tr>
		<td>
			<!-- 컨텐츠 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
		<td align="right" valign="bottom">
			<img id="prodAllButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_goodsAllReg.gif" style='cursor: pointer; border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			<img id="noneDispButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_goodsAllReg4.gif" style='cursor: pointer; border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
<%--             	<input type="button" id="noneDispButton" style='cursor: pointer; border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' value="상품권역 일괄종료"/> --%>
			<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='cursor: pointer; border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
			<img id="uploadButton2" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Upload.gif" width="15" height="15" style='cursor: pointer; border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>' />
		</td>
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
	<tr>
		<td>&nbsp;</td>
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
							<td class="popup_title">코드정보 일괄업로드</td>
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
										<a href="<%=Constances.SYSTEM_IMAGE_URL%>/upload/sample/productDispExcellUploadSample.xlsx">샘플파일 다운로드</a>
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
										<a href="#">
											<img id="importButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type1_excelUpload.gif" style='border:0;' />
										</a>
										<a href="#">
											<img id="closeButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_close.gif" style='border: 0;' />
										</a>
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
</form>
</body>
</html>