<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.*"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList     = (List<ActivitiesDto>) request.getAttribute("useActivityList"); //화면권한가져오기(필수)
	String              listHeight   = "$(window).height()-460 + Number(gridHeightResizePlus)"; //그리드의 width와 Height을 정의
	String              inputWord    = "＋"+CommonUtils.getString( request.getAttribute("inputWord") ); //검색 조건param
	String              srcStartDate = "2009-01-01"; // 날짜 세팅
	String              srcEndDate   = CommonUtils.getCurrentDate();
	LoginUserDto        loginUserDto = CommonUtils.getLoginUserDto(request);
	boolean             isMng        = CommonUtils.isMngUser(loginUserDto);
	List<Map<String, Object>> workInfoList = (List<Map<String, Object>>)request.getAttribute("workInfoList");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<style type="text/css" media="screen">
    th.ui-th-column div{
        white-space:normal !important;
        height:auto !important;
    }
    input[type=radio]{vertical-align: middle;}
</style>
<style type="text/css">
.dispMngtjqmWindow {
    display: none;
    position: absolute;
    top: 5%;
    left: 3%;
    width: 850px;
    background-color: #EEE;
    color: #333;
    z-index: 1003;
}

.jqmWindow {
    display: none;
    
    position: fixed;
    top: 17%;
    left: 50%;
    
    margin-left: -300px;
    width: 700px;
    
/*     background-color: #EEE; */
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
</head>
<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />
<body>
<table width="1500px" style="margin-left: 0px;" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td bgcolor="#FFFFFF">
            <form id="frmSearch" onsubmit="return false;">
            	<table width="1500px"  border="0" cellspacing="0" cellpadding="0">
					<tr valign="top">
	                    <td width="20" valign="middle"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" width="14" height="15"/></td>
	                    <td width="100" class='ptitle'>상품조회</td>
						<td align="center" class="table_td_contents" style="vertical-align: middle;">
							<input type="checkbox" 	id="searchType1"	name="searchType1" 	onclick="javascript:fnSearchType('1');" style="vertical-align: middle;"/>&nbsp;결과내재검색&nbsp;&nbsp;
							<input type="checkbox" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');" style="vertical-align: middle;"/>&nbsp;검색어 제외&nbsp;&nbsp;
							<input type="text" 		id="inputWord" 		name="inputWord" 	placeholder="검색어를 입력하세요" size="50" style="height: 20px;" />
							<input type="hidden" 	id="prevWord" 		name="prevWord"  value="<%=inputWord %>" />
						</td>
	                    <td height="40" align="right" style="vertical-align: bottom;padding-bottom: 1px;">
<% if( isMng == false ){ %>
	                        <button id='regXlsButton' class="btn btn-primary btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 일괄등록양식엑셀다운</button>
<%}%>
	                        <button id='xlsButton' class="btn btn-success btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-file-excel-o"></i> 엑셀</button>
	                        <button id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</button>
	                    </td>
	                </tr>
	            </table>
	            <table width="1500px" border="0" cellspacing="0" cellpadding="0">
	                <tr>
	                    <td colspan="6" class="table_top_line"></td>
	                </tr>
	                <tr>
	                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject">카테고리</td>
	                    <td colspan="3" class="table_td_contents">
	                        <input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px;background-color: #eaeaea;" disabled="disabled"/> 
	                        <input id="srcCateId" name="srcCateId" type="hidden" value="" readonly="readonly" />
	                        <a href="#">
	                            <img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
	                        </a>
	                        <a href="#">
	                            <img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
	                        </a>
	                    </td>
	                    <td class="table_td_subject" width="100">등록일</td>
	                    <td class="table_td_contents">
	                        <input id="srcInsertStartDate" name="srcInsertStartDate" value="<%=srcStartDate%>" type="text" style="width: 75px;" /> ~ <input id="srcInsertEndDate" name="srcInsertEndDate" value="<%=srcEndDate%>" type="text" style="width: 75px;" />
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject" width="100">상품코드</td>
	                    <td class="table_td_contents">
	                        <input id="srcGoodIdenNumb" name="srcGoodIdenNumb"  type="text" value="" size="" maxlength="50" />
	                    </td>
	                    <td class="table_td_subject" width="100">상품명</td>
	                    <td class="table_td_contents">
	                        <input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" />
	                    </td>
	                    <td class="table_td_subject">상품구분</td>
	                    <td class="table_td_contents" id="srcGoodClasCode">
	                       <label><input type="radio" class="input_none" name="srcGoodClasCode" value="" checked/> 전체</label>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject">규격</td>
	                    <td class="table_td_contents">
	                        <input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" />
	                    </td>
	                    <td class="table_td_subject">동의어</td>
	                    <td class="table_td_contents">
	                        <input id="srcGoodSameWord" name="srcGoodSameWord" type="text" value="" size="" maxlength="50" />
	                    </td>
	                    <td class="table_td_subject">정상여부</td>
	                    <td class="table_td_contents">
	                       <label><input type="radio" class="input_none" name="srcIsUse" value=""/> 전체</label>
	                       <label><input type="radio" class="input_none" name="srcIsUse" value="1" checked/> 정상</label>
	                       <label style="color:red"><input type="radio" class="input_none" name="srcIsUse" value="0"/> 종료</label>
	                       <label style="color:red"><input type="radio" class="input_none" name="srcIsUse" value="2"/> 대기</label>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject">공급사</td>
	                    <td class="table_td_contents">
	                        <input id="srcVendorName" name="srcVendorName" type="text" value="" size="" maxlength="50" /> <input id="srcVendorId" name="srcVendorId" type="hidden" value="" />
	                        <a href="#">
	                            <img id="btnVendor" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width: 20px; height: 18px; border: 0;" align="middle" class="icon_search" <%=CommonUtils.getDisplayRoleButton(roleList,"COMM_SAVE")%>" />
	                        </a>
	                    </td>
	                    <td class="table_td_subject">상품담당자</td>
	                    <td class="table_td_contents">
	                        <select class="select" id="srcProductManager" name="srcProductManager">
	                            <option value="">전체</option>
	                        </select>
	                    </td>
	                    <td class="table_td_subject">상품유형</td>
	                    <td class="table_td_contents">
	                       <label><input type="radio" class="input_none" name="srcType" value="" checked/> 전체</label>
	                       <label><input type="radio" class="input_none" name="srcType" value="1"/> 단품</label>
	                       <label><input type="radio" class="input_none" name="srcType" value="0"/> 추가</label>
	                       <label><input type="radio" class="input_none" name="srcType" value="2"/> 옵션</label>
	                       <label><input type="radio" class="input_none" name="srcType" value="3"/> 추가SUB</label>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="6" height="1" bgcolor="eaeaea"></td>
	                </tr>
	                <tr>
	                    <td class="table_td_subject">고객유형</td>
	                    <td class="table_td_contents">
	                    	<select id="srcWorkId" name="srcWorkId" class="select" >
	                    		<option value="">선택</option>
	                    		<option value="0">전체</option>
<%
	if(workInfoList != null && workInfoList.size() > 0){
		for(Map<String, Object> workInfoMap : workInfoList){
%>	                    		
	                    		<option value="<%=CommonUtils.getString(workInfoMap.get("WORKID"))%>"><%=CommonUtils.getString(workInfoMap.get("WORKNM"))%></option>
<%
		}
	}
%>	                    		
	                    	</select>
	                    </td>
	                    <td class="table_td_subject">진열</td>
	                    <td class="table_td_contents" colspan="3">
	                    	<select id="srcDisYn" name="srcDisYn" class="select" >
	                    		<option value="">전체</option>
	                    		<option value="Y">진열</option>
	                    		<option value="N">미진열</option>
	                    	</select>
	                    </td>
	                </tr>
	                <tr>
	                    <td colspan="6" class="table_top_line"></td>
	                </tr>
	                <tr><td height="10"></td></tr>
	            </table>
            </form>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <col width="450" />
                <col />
                <col width="100%"/>
                <tr>
                	<td align="left" valign="middle" style="padding-left: 20px;">
                		<img src="/img/contents/bullet_01.gif" />
                		<span id="searchWordTxt" style="font-size: 10pt;"></span>
                	</td>
                    <td align="right" valign="bottom" width="400px;">
                    	<button id='uploadButton2' class="btn btn-default btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-file-excel-o"></i> 카테고리,동의어 일괄수정</button>
                        <button id='regButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 상품등록</button>
                        <button id='reg2Button' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-floppy-o"></i> 옵션상품등록</button>
                        <button id='btnMultiPdtModify' class="btn btn-success btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 상품일괄변경</button>
                        <button id='btnMultiDispMngt' class="btn btn-success btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 상품진열변경</button>
                        <button id='setButton' class="btn btn-primary btn-xs" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>"><i class="fa fa-pencil"></i> 개인별 항목 설정</button>
                    </td>
                </tr>
                <tr><td height="1" colspan="2"></td></tr>
                <tr>
                    <td valign="top" colspan="2">
                        <div id="jqgrid">
                            <table id="list"></table>
                            <div id="pager"></div>
                        </div>
                    </td>
                </tr>
            </table>
            <div id="dialog" title="Feature not supported" style="display:none;">
                <p>That feature is not supported.</p>
            </div>
            
        </td>
    </tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
    <p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialogSelectRow2" title="Warning" style="display:none;font-size: 12px;color: red;">
    <p>상품일괄변경은 최소 2개 이상의 데이터를 선택 하여야 합니다.</p>
</div>
<!-------------------------------- Dialog Div Start -------------------------------->
<div class="jqmWindow" id="dialogUploadPop">
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
                            <td class="popup_title">카테고리,동의어 일괄수정</td>
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
                                    <td height="23px" class="table_td_contents">1. 상품조회 페이지에서 일괄수정 할 상품을 조회 하십시오</td>
                                </tr>
                                <tr valign="top">
                                    <td height="23px" class="table_td_contents">2. 수정파일 다운로드하여 해당 양식대로 수정할 정보를 입력하십시오.(동의어는 [,]로 구분해 주시고 카테고리코드는 2번째 시트를 참조하십시오!)</td>
                                </tr>
                                <tr valign="top">
                                    <td height="23px" class="table_td_contents">3. 상품코드는 필수이고 상품명,상품규격은 상품을 구분하기 위한 정보제공용 입니다. 상품코드에 카테고리코드 및 동의어가 입력되지 않을 경우 변경되지 않습니다.(입력된 카테고리 및 동의어만 변경)</td>
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
										<button id="downButton" type="button" class="btn btn-success btn-sm"><i class="fa fa-file-excel-o"></i> 수정파일 다운로드</button>
										<button id="importButton" type="button" class="btn btn-primary btn-sm"><i class="fa fa-floppy-o"></i> 엑셀업로드</button>
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
<div class="jqmWindow" id="productPop"></div>
<div class="dispMngtjqmWindow" id="productPopDispMngt"></div>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
<%@ include file="/WEB-INF/jsp/common/vendorListDiv.jsp"%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
$(function(){
	$('#productPop').jqm();
    $('#productPopDispMngt').jqm();
    $('#btnMultiDispMngt').click(function(){
        var rowCnt = $("#list").getGridParam('reccount');
        var chktempcnt = 0;
        var listDataIds = $("#list").getDataIDs();
        for(var i = 0; i < rowCnt; i++){
            var rowid = listDataIds[i];
            if($("#isCheck_"+rowid).attr("checked")) {
            	chktempcnt++;
            }
        }
        if(chktempcnt == 0){
			$("#dialogSelectRow").dialog();
            return;
        }
        $('#productPopDispMngt').css({'width':'600px','top':'15%','left':'20%'}).html('')
        .load('/product/popMultiDispMngt.sys')
        .jqmShow();
    });

    $.ajaxSetup ({
        cache: false
    });
    fnDataInit();
    fnDateInit();
    fnGridInit();
    $('#btnSearchCategory').click(function()    {   fnCategoryPopOpen();                                                                    });
    $("#srcMajoCodeName").keydown(function(e)   {   if(e.keyCode==13) { $("#btnSearchCategory").click(); }                                  });
    $('#btnEraseCategory').click(function()     {   $("#srcMajoCodeName").val(''); $("#srcCateId").val('');                                 });
    $("#btnVendor").click(function()            {   fnVendorSearchOpenPop();                                                                });
    $("#srcVendorName").keydown(function(e)     {   if(e.keyCode==13) { $("#btnVendor").click(); }                                          });
    $("#srcVendorName").change(function(e)      {   $("#srcVendorName").val("");    $("#srcVendorId").val("");                              });
    $('#btnMultiPdtModify').click(function()    {   fnMultiPrtPop();                                                                    });
        
    //상품담당자
    selectProductManager();
    $('#srcButton').click(function (e) {
        fnSearch();
    });
    $('#regButton').click(function (e) {
        var url = '/product/popProductAdm.sys';
    	var win = window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
        win.focus();
    });
    $('#reg2Button').click(function (e) {
        var url = '/product/popProductAdm.sys?opt=';
        var win = window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
        win.focus();
    });
    $('#setButton').click(function () {
    	$("#list").jqGrid('columnChooser', {
            done: function (perm) {
                fnSaveColumn("#list");
                // 1. 저장할 그리드의 아이디를 넣어줌. 
            }
        });
    });
    $('#regButton2').click(function (e) {
        var url = '/product/productRegist.sys';
        var win = window.open(url, 'okplazaPop', 'width=917, height=900, scrollbars=yes, status=no, resizable=no');
        win.focus();
    });
	$('#xlsButton').click(function (e) {
<% if( isMng == false ){ %>
		var colLabels = [
			'상품코드',		'구분',		'유형',			'상품명',		'규격',			'단위',
			'공급사',		'진열',		'제조사','이미지',	'상세설명',		'판매가',		'매입가',
			'재고량',		'물량배분',	'표준 납기일',	'대카테고리',	'중카테고리',
			'소카테고리',	'동의어',	'등록일',		'담당자',		'최소 수량',
			'마진율',		'권역',		'고객유형',		'사업장'
		];   //출력컬럼명
		var colIds = [
			'GOOD_IDEN_NUMB',		'GOOD_TYPE_NM',		'REPRE_GOOD_NM',	'GOOD_NAME',		'GOOD_SPEC',		'ORDER_UNIT',
			'VENDORNM',				'DIS_YN',			'MAKE_COMP_NAME',	'IMG_YN',			'DESC_YN',			'SELL_PRICE',		'SALE_UNIT_PRIC',
			'GOOD_INVENTORY_CNT',	'ISDISTRIBUTENM',	'DELI_MINI_DAY',	'CATE_NAME_1ST',	'CATE_NAME_2ST',
			'CATE_NAME_3ST',		'GOOD_SAME_WORD',	'INSERT_DATE',		'PRODUCT_MANAGER',	'DELI_MINI_QUAN',
			'VENDOR_SELL_RATE',		'DELI',				'WORK',				'BRANCH'
		];   //출력컬럼ID
// 		var figureColIds = ['GOOD_IDEN_NUMB','VENDOR_SELL_RATE'];
		var figureColIds = ['GOOD_IDEN_NUMB'];
<% }else{ %>
		var colLabels = [
			'상품코드',	'구분',			'유형',			'상품명',		'규격',			'단위',
			'공급사',	'진열',			'제조사','이미지',		'상세설명',		'판매가',		'재고량',
			'물량배분',	'표준 납기일',	'대카테고리',	'중카테고리',	'소카테고리',
			'동의어',	'등록일',		'담당자'
		];   //출력컬럼명
		var colIds = [
			'GOOD_IDEN_NUMB',	'GOOD_TYPE_NM',		'REPRE_GOOD_NM',	'GOOD_NAME',		'GOOD_SPEC',			'ORDER_UNIT',
			'VENDORNM',			'DIS_YN',			'MAKE_COMP_NAME','IMG_YN',			'DESC_YN',			'SELL_PRICE',		'GOOD_INVENTORY_CNT',
			'ISDISTRIBUTENM',	'DELI_MINI_DAY',	'CATE_NAME_1ST',	'CATE_NAME_2ST',	'CATE_NAME_3ST',
			'GOOD_SAME_WORD',	'INSERT_DATE',		'PRODUCT_MANAGER'
		];   //출력컬럼ID
		var figureColIds = ['GOOD_IDEN_NUMB'];
<% } %>
		var numColIds = [
			'SELL_PRICE', 'SALE_UNIT_PRIC', 'GOOD_INVENTORY_CNT', 'DELI_MINI_DAY', 'DELI_MINI_QUAN'
		];  //숫자표현ID
		
		
		var sheetTitle = "상품조회"; //sheet 타이틀
		var excelFileName = "productList";  //file명/product/selectProductList/list.sys
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcCateId';
		fieldSearchParamArray[1] = 'srcInsertStartDate';
		fieldSearchParamArray[2] = 'srcInsertEndDate';
		fieldSearchParamArray[3] = 'srcGoodIdenNumb';
		fieldSearchParamArray[4] = 'srcGoodName';
		fieldSearchParamArray[5] = 'srcGoodClasCode';
		fieldSearchParamArray[6] = 'srcGoodSpecDesc';
		fieldSearchParamArray[7] = 'srcGoodSameWord';
		fieldSearchParamArray[8] = 'srcIsUse';
		fieldSearchParamArray[9] = 'srcVendorName';
		fieldSearchParamArray[10] = 'srcVendorId';
		fieldSearchParamArray[11] = 'srcProductManager';
		fieldSearchParamArray[12] = 'srcType';
		fieldSearchParamArray[13] = 'srcWorkId';
		fieldSearchParamArray[14] = 'srcDisYn';
		fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/productListExcelAdm.sys", figureColIds);
	});
//     $('#frmSearch').search();
//	fnSearch();
    
    $("#frmSearch #inputWord").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcInsertStartDate").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcInsertEndDate").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcGoodIdenNumb").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcGoodName").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcGoodSpecDesc").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    $("#frmSearch #srcGoodSameWord").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});
    
    var btnUpload=$('#importButton');
    var status=$('#status');
    new AjaxUpload(btnUpload, {
        action: '<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productModifyExcelUpload.sys',
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
            $('#dialogUploadPop').jqmHide();
            if(fnTransResult(response,true)) {
            	$("#list").jqGrid("setGridParam", {'page':1,'postData':$('#frmSearch').serializeObject()}).trigger("reloadGrid");
            }
        }
    });
    // Dialog Button Event
    $('#dialogUploadPop').jqm();  //Dialog 초기화
    $("#uploadButton2").click(function(){
    	if(!confirm("상품조회 페이지에서 일괄 수정 할 상품을 조회 하십시오!\n계속 하시겠습니까?")) return;
        $('#dialogUploadPop').jqmShow();
    });
    $("#closeButton").click(function(){ //Dialog 닫기
        $('#dialogUploadPop').jqmHide();
    });
    $('#dialogUploadPop').jqm().jqDrag('#dialogHandle');
    
    $("#downButton").click(function(){	//수정파일 다운로드
        var colLabels = ['상품코드','상품명','규격','수정_카테고리코드','수정_동의어([,]로 구분, 최대5개)'];
        var colIds = ['GOOD_IDEN_NUMB','GOOD_NAME','GOOD_SPEC','CATE_CD','GOOD_SAME_WORD'];
        var numColIds = [];  //숫자표현ID
        var sheetTitle = '수정할정보'; //sheet 타이틀
        var excelFileName = "uploadProductModify";  //file명/product/selectProductList/list.sys
    	var fieldSearchParamArray = new Array();     //파라메타 변수ID
    	fieldSearchParamArray[0] = 'srcCateId';
    	fieldSearchParamArray[1] = 'srcInsertStartDate';
    	fieldSearchParamArray[2] = 'srcInsertEndDate';
    	fieldSearchParamArray[3] = 'srcGoodIdenNumb';
    	fieldSearchParamArray[4] = 'srcGoodName';
    	fieldSearchParamArray[5] = 'srcGoodClasCode';
    	fieldSearchParamArray[6] = 'srcGoodSpecDesc';
    	fieldSearchParamArray[7] = 'srcGoodSameWord';
    	fieldSearchParamArray[8] = 'srcIsUse';
    	fieldSearchParamArray[9] = 'srcVendorName';
    	fieldSearchParamArray[10] = 'srcVendorId';
    	fieldSearchParamArray[11] = 'srcProductManager';
    	fieldSearchParamArray[12] = 'srcType';
    	fieldSearchParamArray[13] = 'srcWorkId';
    	fieldSearchParamArray[14] = 'srcDisYn';
        fnExportExcelToSvc($("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/productModifyExcelAdm.sys");
    });
    
    
<% if( isMng == false ){ %>
	$('#regXlsButton').click(function (e) {
		var colLabels = [
             '*상품코드' ,'*카테고리코드' ,'*상품명' ,'*상품실적년' ,'*신규사업' ,'규격' ,'Ø' ,'w' ,'D' ,'H'
             ,'L' ,'t' ,'M(미터)' ,'재질' ,'크기' ,'색상' ,'TYPE' ,'총중량' ,'실중량' ,'*과세구분'
             ,'*상품담당자' ,'*주문단위' ,'*상품구분' ,'*공급사노출' ,'*물량배분' ,'*재고관리' ,'*추가구성' ,'*운영사이미지관리' ,'*공급사코드' ,'*종료여부'
             ,'*판매가' ,'*매입가' ,'*최소주문수량' ,'*납품소요일' ,'*물량배분율' ,'*제조사' ,'*하도급' ,'*재고수량' ,'*상품우선순위'
		];   
		var colIds = [
            'GOOD_IDEN_NUMB' ,'CATE_CD' ,'GOOD_NAME' ,'GOOD_REG_YEAR' ,'NEW_BUSI' ,'SPEC_SPEC' ,'SPEC_PI' ,'SPEC_WIDTH' ,'SPEC_DEEP' ,'SPEC_HEIGHT'
            ,'SPEC_LITER' ,'SPEC_TON' ,'SPEC_METER' ,'SPEC_MATERIAL' ,'SPEC_SIZE' ,'SPEC_COLOR' ,'SPEC_TYPE', 'SPEC_WEIGHT_SUM'  ,'SPEC_WEIGHT_REAL' ,'VTAX_CLAS_CODE'
            ,'PRODUCT_MANAGER' ,'ORDER_UNIT' ,'GOOD_TYPE' ,'VENDOR_EXPOSE' ,'ISDISTRIBUTE' ,'STOCK_MNGT' ,'ADD_GOOD' ,'SKTS_IMG' ,'VENDORCD' ,'ISUSE'
            ,'SELL_PRICE' ,'SALE_UNIT_PRIC' ,'DELI_MINI_QUAN' ,'DELI_MINI_DAY' ,'DISTRI_RATE' ,'MAKE_COMP_NAME' ,'ISSUB_ONTRACT' ,'GOOD_INVENTORY_CNT' ,'VENDOR_PRIORITY'
		];   
		var numColIds = [ 'SELL_PRICE', 'SALE_UNIT_PRIC', 'GOOD_INVENTORY_CNT', 'DELI_MINI_DAY', 'DELI_MINI_QUAN', 'VENDOR_PRIORITY'];  
		var sheetTitle = "상품정보"; //sheet 타이틀
		var excelFileName = "allFormGoodList";  //file명/product/selectProductList/list.sys
		var fieldSearchParamArray = new Array();     //파라메타 변수ID
		fieldSearchParamArray[0] = 'srcCateId';
		fieldSearchParamArray[1] = 'srcInsertStartDate';
		fieldSearchParamArray[2] = 'srcInsertEndDate';
		fieldSearchParamArray[3] = 'srcGoodIdenNumb';
		fieldSearchParamArray[4] = 'srcGoodName';
		fieldSearchParamArray[5] = 'srcGoodClasCode';
		fieldSearchParamArray[6] = 'srcGoodSpecDesc';
		fieldSearchParamArray[7] = 'srcGoodSameWord';
		fieldSearchParamArray[8] = 'srcIsUse';
		fieldSearchParamArray[9] = 'srcVendorName';
		fieldSearchParamArray[10] = 'srcVendorId';
		fieldSearchParamArray[11] = 'srcProductManager';
		fieldSearchParamArray[12] = 'srcType';
		fieldSearchParamArray[13] = 'srcWorkId';
		fieldSearchParamArray[14] = 'srcDisYn';
		fnExportExcelToSvc(null, colLabels, colIds, numColIds, sheetTitle, excelFileName, "", fieldSearchParamArray, "/product/allFormGoodExcelList.sys");
	});
<%}%>
});
//코드 데이터 초기화 
function fnDataInit(){
     $.post(  //조회조건의 품목유형1 세팅
         '<%=Constances.SYSTEM_CONTEXT_PATH %>/common/getCodeList.sys',
         {
             codeTypeCd:"ORDERGOODSTYPE",
             isUse:"1"
         },
         function(arg){
             var codeList = eval('(' + arg + ')').codeList;
             for(var i=0;i<codeList.length;i++) {
                 $("#srcGoodClasCode").append('<label><input type="radio" class="input_none" name="srcGoodClasCode" value="'+codeList[i].codeVal1+'"/> '+codeList[i].codeNm1+'</label>');
             }
         }
     );
}
//날짜 데이터 초기화 
function fnDateInit() {
    $("#srcInsertStartDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("#srcInsertEndDate").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd"
        }
    );
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
}
function funcImageView(imgPath) {
	$('#productPop').css({'width':'500px','top':'40%','left':'40%'}).html('')
    .load('/menu/product/product/popBigImage.sys?bigImage='+imgPath)
    .jqmShow();
}
function funcDescView(good_iden_numb,vendorid) {
	$('#productPop').css({'width':'700px','top':'40%','left':'40%'}).html('')
    .load('/menu/product/product/popProductDesc.sys?good_iden_numb='+good_iden_numb+"&vendorid="+vendorid)
    .jqmShow();
}
var subGrid = null;
//그리드 초기화
function fnGridInit() {
<%
    String listColNames = "";
	if(!isMng){
		listColNames = "['<input id=\"chkAllOutputField\" type=\"checkbox\" style=\"border:0px;\" onclick=\"allCheckBox(event)\" />','상품코드','구분','유형','상품명','규격','단위','공급사','진열','이미지','이미지YN','상세<br/>설명','판매가','매입가','이익률','최소<br/>수량','재고량','물량<br/>배분','표준<br/>납기','등록일','담당자','','','']";
	} else{
		listColNames = "['<input id=\"chkAllOutputField\" type=\"checkbox\" style=\"border:0px;\" onclick=\"allCheckBox(event)\" />','상품코드','구분','유형','상품명','규격','단위','공급사','진열','이미지','이미지YN','상세<br/>설명','판매가','최소<br/>수량','재고량','물량<br/>배분','표준<br/>납기','등록일','담당자','','','']";
	}
%>
    $("#list").jqGrid({
        url:'<%=Constances.SYSTEM_CONTEXT_PATH %>/product/selectProductAdmList.sys',
        datatype: 'local',
        mtype: 'POST',
		colNames:<%=listColNames %>,
        // 3. 저장된 colModel이 있음 그걸로 사용 아님 정의
        colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false, formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
            {name:'GOOD_IDEN_NUMB',width:80,align:'center'},//상품코드
            {name:'GOOD_TYPE_NM',width:30,align:'center'},//구분
            {name:'REPRE_GOOD_NM',width:30,align:'center'},//유형
            {name:'GOOD_NAME',width:190},//상품명
            {name:'GOOD_SPEC',width:190},//규격
            {name:'ORDER_UNIT',width:35,align:'center'},//단위
            {name:'VENDORNM',width:120},//공급사
            {name:'DIS_YN',width:30,align:'center'},//진열YN
            {name:'SMALL_IMG_PATH',width:40,align:'center'},//이미지
            {name:'IMG_YN',width:40,align:'center',hidden:true},//이미지YN
            {name:'DESC_YN',width:40,align:'center'},//상세설명
            {name:'SELL_PRICE',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//판매가
<%	if(!isMng){	%>
            {name:'SALE_UNIT_PRIC',width:60,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//매입가
            {name:'VENDOR_SELL_RATE',width:45,align:'right',formatter:vendorRateFormatter},//매익율
<%	}	%>
            {name:'DELI_MINI_QUAN',width:40,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//최소수량
            {name:'GOOD_INVENTORY_CNT',width:40,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//재고량
            {name:'ISDISTRIBUTENM',width:30,align:'center'},//물량배분
            {name:'DELI_MINI_DAY',width:30,align:'right',sorttype:'integer',formatter:'integer',
                formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }},//표준 납기일
            {name:'INSERT_DATE',width:80,align:'center'},//등록일
            {name:'PRODUCT_MANAGER',width:140},//담당자
            {name:'VENDORID',hidden:true,hidedlg:true},//VENDORID
            {name:'ORIGINAL_IMG_PATH',hidden:true,hidedlg:true},
            {name:'ISUSE',hidden:true,hidedlg:true}
        ],
        postData: $('#frmSearch').serializeObject(),  
        rowNum:30, rownumbers:true, rowList:[30,50,100,200,500,1000], pager: '#pager',
        height:<%=listHeight%>,autowidth:true,
        sortname: 'GOOD_IDEN_NUMB', sortorder: 'desc', 
        viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false,
//         loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
        jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"},
        afterInsertRow: function(rowid, aData) {
        	var selrowContent = $("#list").jqGrid('getRowData',rowid);
        	if((selrowContent.SMALL_IMG_PATH).length>0) {
        		var imgTag = "<a href='javascript:funcImageView(\""+selrowContent.ORIGINAL_IMG_PATH+"\")'><img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.SMALL_IMG_PATH+"' style='width:35px;height:35px;' /></a>";
        		$('#list').jqGrid('setRowData',rowid,{SMALL_IMG_PATH:imgTag});
        	}
        	if(selrowContent.DESC_YN=='Y') {
        		$(this).setCell(rowid,'DESC_YN','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
        	}
        	if(aData.ISUSE!='1') {
        		$("#"+rowid).css("background", "#fdeccd");
        	}
<%	if(!isMng){	%>
			$(this).setCell(rowid,'GOOD_NAME','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
			$(this).setCell(rowid,'VENDORNM','',{color:'#0000ff',cursor:'pointer','text-decoration':'underline'});
<%	}	%>
        },
        onCellSelect: function(rowid, iCol, cellcontent, target) {
            var selrowContent = $("#list").jqGrid('getRowData',rowid);
            var cm = $("#list").jqGrid("getGridParam", "colModel");
            var colName = cm[iCol];
<%	if(!isMng){	%>
            if(colName != undefined &&colName['name']=="GOOD_NAME") {
                var url = '/product/popProductAdm.sys?good_iden_numb=' + selrowContent.GOOD_IDEN_NUMB + '&vendorid=' + selrowContent.VENDORID;
                var win = window.open(url, 'okplazaPop', 'width=917, height=800, scrollbars=yes, status=no, resizable=no');
                win.focus();
            }
            if(colName != undefined &&colName['name']=="VENDORNM") {
				$("#list").setSelection(rowid);
				onDetail();
            }
<%	}	%>
			if(colName != undefined &&colName['name']=="DESC_YN") {
				if(selrowContent.DESC_YN=='Y') {
					funcDescView(selrowContent.GOOD_IDEN_NUMB,selrowContent.VENDORID);
				}
			}
        }
    })
    .jqGrid("setLabel", "rn", "순번");
}


function onDetail(){
	var row = jq("#list").jqGrid('getGridParam','selrow'); // 선택된 로우 조회
	if( row != null ){
		var selrowContent = jq("#list").jqGrid('getRowData',row);        // 선택된 로우의 데이터 객체 조회
		var popurl = "/organ/organVendorDetail.sys?vendorId=" + selrowContent.VENDORID;
		var popproperty = "dialogWidth:920px;dialogHeight=650px;scroll=yes;status=no;resizable=no;";
	    window.open(popurl, 'okplazaPop', 'width=920, height=670, scrollbars=yes, status=no, resizable=no');
	} else { jq( "#dialogSelectRow" ).dialog(); }	
}

function vendorRateFormatter(cellvalue, options, rowObject) {
	return cellvalue+"%";
}
function checkboxFormatter(cellvalue, options, rowObject) {
	var checkBox = "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0 ; height:30px;' offval='no'  />";
	return checkBox;
}
function fnIsChecked(rowid){
	if($("#isCheck_" + rowid ).prop("checked") == true){
		$("#isCheck_" + rowid ).prop("checked",false);
	}else{
		$("#isCheck_" + rowid ).prop("checked",true);
	}
}
function allCheckBox(e) {
	e = e||event;/* get IE event ( not passed ) */
	e.stopPropagation? e.stopPropagation() : e.cancelBubble = true;

// 	if($("#chkAllOutputField").prop("checked") == true){
// 		$("#chkAllOutputField").prop("checked",false);
// 	}else{
// 		$("#chkAllOutputField").prop("checked",true);
// 	}
	
	if($("#chkAllOutputField").is(':checked')) {
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq('input:checkbox[name=isCheck_'+rowid+']:not(checked)').attr("checked", true);
			}
		}
	} else {
		var rowCnt = jq("#list").getGridParam('reccount');
		if(rowCnt>0) {
			for(var i=0; i<rowCnt; i++) {
				var rowid = $("#list").getDataIDs()[i];
				jq('input:checkbox[name=isCheck_'+rowid+']:checked').attr("checked", false);
			}
		}
	}
}


// Resizing
$(window).bind('resize', function() { 
    $("#list").setGridHeight(<%=listHeight %>);
    $("#list").setGridWidth(1500);
}).trigger('resize');
// 조회 등록/수정/삭제 후에도 처리하기에 꼭 펑션으로 사용함. 
function fnSearch() {
	
	$("#list").jqGrid("clearGridData", true);
	if($("#frmSearch #searchType1").prop("checked") && ($.trim($("#frmSearch #inputWord").val()) != '')) {
		$("#frmSearch #prevWord").val( $("#frmSearch #prevWord").val()+"‡"+"＋"+$.trim($("#frmSearch #inputWord").val()) );
	} else if($("#frmSearch #searchType2").prop("checked") && ($.trim($("#frmSearch #inputWord").val()) != '')) {
		$("#frmSearch #prevWord").val( $("#frmSearch #prevWord").val()+"‡"+"－"+$.trim($("#frmSearch #inputWord").val()) );
	} else if(($("#frmSearch #searchType1").prop("checked")==false && $("#frmSearch #searchType2").prop("checked")==false) && ($.trim($("#frmSearch #inputWord").val()) != '')) {
		$("#frmSearch #prevWord").val( "＋"+$.trim($("#frmSearch #inputWord").val()) );
	} else if(($("#frmSearch #searchType1").prop("checked")==false && $("#frmSearch #searchType2").prop("checked")==false)) {
		$("#frmSearch #prevWord").val('');
	}
	
    $("#list")
    .jqGrid("setGridParam", {'page':1,"datatype":"json",'postData':$('#frmSearch').serializeObject()})
    .trigger("reloadGrid");
    
    $("#frmSearch #inputWord").val('');
    fnSetWord(-1);
}
/**
 * 검색결과 문자열 세팅
 */
function fnSetWord(index) {
	var sSearchWordTxt = "";
	var eSearchWordTxt = "";
	var sPrefix = "";
	var ePrefix = "";
	var eCnt = 0;
	var sCnt = 0;
    var prevWordArray = $.trim($("#frmSearch #prevWord").val()).split("‡");
    for(var i = 0 ; i < prevWordArray.length ; i++){
    	if(i!=index) {
			if(prevWordArray[i].indexOf('＋') > -1){
				if(sCnt != 0) sPrefix = ",";
				if(prevWordArray[i].substring(1) != ''){
					sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
					sCnt++;
				}else{
					sSearchWordTxt += '';
				}
			} else if(prevWordArray[i].indexOf('－') > -1){
				if(eCnt != 0) ePrefix = ",";
				if(prevWordArray[i].substring(1) != ''){
					eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "' <a href='javascript:fnSrcWordDel(\""+i+"\")'><img src='/img/FR/close_icon.gif' width='15px' heigth='15px' /></a>";
					eCnt++;
				}else{
					eSearchWordTxt += '';
				}
			}
    	}
    }
	var resultTxt = "";
	if(sCnt > 0){
		if(eCnt == 0) 	resultTxt = "<strong style='color: red;'>"+sSearchWordTxt + "</strong> 의 검색결과";
		else			resultTxt = "<strong style='color: red;'>"+sSearchWordTxt + "</strong> 중 <strong style='color: red;'>" + eSearchWordTxt + "</strong> 을(를) 제외한 검색결과";
	}else{
		resultTxt = "&nbsp;";
	}
	$("#searchWordTxt").html(resultTxt);
}
/**
 * 검색결과 제거검색
 */
function fnSrcWordDel(index){
	fnSetWord(index);
	var prevWordArray = $.trim($("#frmSearch #prevWord").val()).split("‡");
	var wordString = "";
	for(var i = 0 ; i < prevWordArray.length ; i++){
		if(i!=index) {
			if(wordString=="") wordString = prevWordArray[i];
			else wordString = wordString + "‡" + prevWordArray[i];
		}
	}
	$("#frmSearch #prevWord").val(wordString);
	fnSearch();
}
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
/**
 * 결과내재검색/검색어 제외 체크박스
 */
function fnSearchType(kind){
	if(kind == '1'){
		$("#searchType2").prop("checked", false);
	}else if(kind == '2'){
		$("#searchType1").prop("checked", false);
	}
}

function fnMultiPrtPop(){
	
	
    var rowCnt = $("#list").getGridParam('reccount');
    var chktempcnt = 0;
    var listDataIds = $("#list").getDataIDs();
	var params = "";
    for(var i = 0; i < rowCnt; i++){
        var rowid = listDataIds[i];
        var selrowContent = $("#list").jqGrid('getRowData',rowid);
        if($("#isCheck_"+rowid).attr("checked")) {
        	if(chktempcnt == 0){
        		params += "goodIdenNumb=" + selrowContent.GOOD_IDEN_NUMB + "&vendorId="+selrowContent.VENDORID;
        	}else{
	        	params += "&goodIdenNumb=" + selrowContent.GOOD_IDEN_NUMB + "&vendorId="+selrowContent.VENDORID;
        	}
        	chktempcnt++;
        }
    }
    if(chktempcnt < 2){
		$("#dialogSelectRow2").dialog();
        return;
    }
    
    var popForm = fnGetDynamicForm("/product/popMultiProductAdm.sys", params, "okplazaMultiPop");
    var win = window.open('', 'okplazaMultiPop', 'width=917, height=450, scrollbars=yes, status=no, resizable=no');
    win.focus();
	
    var body = document.getElementsByTagName("body")[0];
    body.appendChild(popForm);
    popForm.submit();
	body.removeChild(popForm);
}
</script>
</body>
</html>