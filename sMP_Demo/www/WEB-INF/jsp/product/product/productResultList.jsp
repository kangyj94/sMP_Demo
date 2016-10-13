<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@ page import="java.util.List" %>

<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-240 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");			//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);	//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcInsertStartDate = "2009-01-01";																// 날짜 세팅
	String srcInsertEndDate = CommonUtils.getCurrentDate();
	String managementFlag = CommonUtils.getString(request.getParameter("flag1"));
	String startDate = CommonUtils.getString(request.getParameter("startDate"));
	String endDate = CommonUtils.getString(request.getParameter("endDate"));
	String inputWord = CommonUtils.getString(request.getParameter("inputWord"));
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$("#prevWord").val("＋"+$.trim("<%=inputWord%>"));
	
	$("#searchWordTxt").html("'<%=inputWord%>' 의 검색결과");
	
	$.blockUI({});
	fnInitJqGridComponent();
	
	$("#inputWord").keydown(function(e){ if(e.keyCode==13) { fnSearch(); }});	
	
});

// 리싸이즈 설정 
$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');

// 상품 상세 수정후 그리드 다시 그리기
function fnReLoadDataGrid(){
	fnSearch();
}

</script>

<!-- 이벤트 스크립트 -->
<script type="text/javascript">
// 조회 
function fnSearch() {
	$.blockUI({});
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	var searchType = '';
	
	if($("#searchType1").prop("checked") || $("#searchType2").prop("checked")){
		if($("#searchType1").prop("checked")){
			$("#prevWord").val($("#prevWord").val() + "‡＋" + $("#inputWord").val());
			searchType = 'Y';
		}
		
		if($("#searchType2").prop("checked")){
			$("#prevWord").val($("#prevWord").val() + "‡－" + $("#inputWord").val());
			searchType = 'Y';
		}
	}else{
		$("#prevWord").val("＋"+$("#inputWord").val());
		searchType = 'N';
	}
	
	data.searchType = searchType;
	data.inputWord 	= $('#inputWord').val();
	data.prevWord 	= $('#prevWord').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}


//이미지 Error 체크 
function fnCheackErrImg(){ 
	$('img').error(function(){
		$(this).attr('src', '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
	});
}

function fnSearchType(kind){
	if(kind == '1'){
		$("#searchType2").prop("checked", false);
	}else if(kind == '2'){
		$("#searchType1").prop("checked", false);
	}
}

</script>


<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
/**
 * 그리드 
 */
function fnInitJqGridComponent(){
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/productResultListJQGrid.sys',
		datatype: "json",
// 		datatype: "local",
		mtype:'POST',
		colNames:['상품코드','카테고리코드','상품명','판매가산출옵션','기준매익률','절대판매가','과거상품주문여부','공급사코드','최소주문수량',
					'표준규격','상품규격','이미지','공급사','엑셀규격','과세구분','배분여부','판매단가','매입단가','단위', '재고량', '카테고리','상품담당자','이미지여부','설명여부',
					'상품구분','표준납기일','정상여부','동의어','상품우선순위','cate_Id','original_Img_Path', 'small_Img_Path' ,'공급사'
				],
		colModel:[
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:80,align:"left",search:false,sortable:true,editable:false },//상품코드
			{name:'cate_cd', index:'cate_cd',hidden:true,search:false},//	카테고리코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'sale_Criterion_Type', index:'sale_Criterion_Type', hidden:true,search:false},//	판매가산출옵션
			{name:'stan_Buying_Rate',index:'Stan_Buying_Rate',hidden:true,search:false},//	기준매익률
			{name:'stan_Buying_Money',index:'Stan_Buying_Money',hidden:true,search:false},//	절대판매가
			{name:'isDispPastGood', index:'isDispPastGood',hidden:true,search:false},//	과거상품주문여부
			{name:'vendorcd',index:'vendorcd',hidden:true,search:false},//	공급사 코드
			{name:'deli_Mini_Quan',index:'deli_Mini_Quan',hidden:true,search:false},//	최소주문수량
			//{name:'valRlt', index:'valRlt', hidden:true},//	정합성
			//{name:'rtnError', index:'rtnError', hidden:true},//	에러
			{name:'good_St_Spec_Desc',index:'good_St_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{name:'good_Spec_Desc',index:'good_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false },//규격
			{name:'good_img', index:'good_img',width:37,align:"center",search:false,sortable:false,editable:false },//이미지
			{name:'vendorNm',index:'vendorNm',width:100,align:'left',search:false,sortable:false,editable:false },//공급사명
			{name:'excelGood_Spec_Desc',index:'excelGood_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//엑셀규격
			{name:'vtax_Clas_Code',index:'vtax_Clas_Code',width:60,align:"center",search:false,sortable:false,
				editable:false,formatter:"select",editoptions:{value:"10:과세10%;20:영세율;30:면세"}
			},//과세구분
			{name:'isDistribute',index:'isDistribute',width:60,align:"center",search:false,sortable:false,
					editable:false,formatter:"select",editoptions:{value:"1:Y;0:N"}
			},//물량배분여부
			{name:'sell_Price',index:'sell_Price',width:60,align:"right",search:false,sortable:false,
				editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//판매단가
			{name:'sale_Unit_Pric',index:'sale_Unit_Pric',width:60,align:"right",search:false,sortable:false,
				editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매입단가
			{name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{name:'good_Inventory_Cnt',index:'good_Inventory_Cnt',width:60,align:"right",search:false,sortable:false,
				editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//재고량
			{name:'full_Cate_Name',index:'full_Cate_Name',width:240,align:'left',search:false,sortable:false,editable:false },//카테고리명
			{name:'product_manager',index:'product_manager',width:150,align:'center',search:false,sortable:false,editable:false },//상품담당자
			{name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//대표이미지여부
			{name:'isSetDesc',index:'isSetDesc',width:60,align:"center",search:false,sortable:false,editable:false },//상품설명여부
			{name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:false,
				editable:false,formatter:"select",editoptions:{value:"10:일반;20:지정;30:수탁;40:사급형 지입;50:사급"}
			},//상품구분
			{name:'deli_Mini_Day',index:'deli_Mini_Day',width:100,align:"center",search:false,sortable:false,editable:false},//	납품소요일
			{name:'isUse',index:'isUse',width:60,align:"center",search:false,sortable:false,editable:false},//정상여부
			{name:'good_Same_Word',index:'good_Same_Word',width:160,align:"center",search:false,sortable:false,editable:false },//동의어
			{name:'vendor_priority',index:'vendor_priority',width:160,align:"center",search:false,sortable:false,editable:false },//상품운선순위
			{name:'cate_Id',index:'cate_Id',hidden:true,search:false },
			{name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false },
			{name:'original_Img_Path',index:'original_Img_Path',hidden:true,search:false },
			{name:'vendorId',index:'vendorId',hidden:true,search:false }
		],
		postData: {
			inputWord:$("#inputWord").val(),
			inputWord:$("#prevWord").val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100,500],pager:'#pager',
		height:<%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'good_Name',sortorder:'Desc',
		caption:"상품정보",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
			<% } %>
			// 품목 규격 설정 
			var prodSpcNm = new Array();
			<% for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
			<% }%>
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				
				
				// 규격 화면 로드
				var argStArray = selrowContent.good_St_Spec_Desc.split("‡");
				var argArray = selrowContent.good_Spec_Desc.split("‡");
				
				var prodStSpec = "";
				var excelProdStSpec = "";
				var prodSpec = "";
			
				for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
					if(argStArray[stIdx] > ' ') {
						prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
					}
				}
				if(prodStSpec.length > 0) {
					prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
					excelProdStSpec = prodStSpec;
					prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
				}
			
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
					if(argArray[jIdx] > ' ') {
						if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
						else           prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
					}
				}
				prodStSpec += prodSpec;
				excelProdStSpec += prodSpec;
			
				jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodStSpec});
				jQuery('#list').jqGrid('setRowData',rowid,{excelGood_Spec_Desc:excelProdStSpec});
			
//             // 규격 화면 로드 
//             var argArray = selrowContent.good_Spec_Desc.split("‡");
//             var prodSpec = "";
//             for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
//                if(argArray[jIdx] > ' ') {
//                      prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
//                }
//             }
//             jQuery('#list').jqGrid('setRowData',rowid,{good_Spec_Desc:prodSpec});
            
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:35px;height:35px;' />";   
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
				jQuery('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
				
				// 동의어 
				var good_Same_Word = selrowContent.good_Same_Word.replace(/‡/gi, " ");
				jQuery('#list').jqGrid('setRowData',rowid,{good_Same_Word:good_Same_Word});
				if(selrowContent.isUse == "1"){
					jQuery('#list').jqGrid('setRowData',rowid,{isUse:"정상"});
				}else{
					jQuery('#list').jqGrid('setRowData',rowid,{isUse:"종료"});
				}
				if(selrowContent.isUse == "2"){
					jQuery('#list').jqGrid('setRowData',rowid,{isUse:"대기"});	
				}	
			}
			fnCheackErrImg(); 
			
			$("#inputWord").blur();
			$("#searchType1").prop("checked", false);
			$("#searchType2").prop("checked", false);
			
			var prevWordArray = $.trim($("#prevWord").val()).split("‡");
			var sSearchWordTxt = "";
			var eSearchWordTxt = "";
			var sPrefix = "";
			var ePrefix = "";
			var eCnt = 0;
			var sCnt = 0;
			
			for(var i = 0 ; i < prevWordArray.length ; i++){
				if(prevWordArray[i].indexOf('＋') > -1){
					if(sCnt != 0) sPrefix = ",";
					sSearchWordTxt += sPrefix + " '" + prevWordArray[i].substring(1) + "'";
					sCnt++;
				}
				
				if(prevWordArray[i].indexOf('－') > -1){
					if(eCnt != 0) ePrefix = ",";
					eSearchWordTxt += ePrefix + " '" + prevWordArray[i].substring(1) + "'";
					eCnt++;
				}
			}
			
			var resultTxt = "";
			
			if(eCnt == 0) 	resultTxt = sSearchWordTxt + " 의 검색결과";
			else			resultTxt = sSearchWordTxt + " 중 " + eSearchWordTxt + " 을(를) 제외한 검색결과";
			 
			$("#searchWordTxt").html(resultTxt);

			$.unblockUI();
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && (cm[iCol].index == 'good_Iden_Numb' || cm[iCol].index == 'good_Name' )){
				var mstDatas = $("#list").jqGrid('getRowData',rowid);
				editRow(mstDatas['good_Iden_Numb'] , mstDatas['vendorId']);
			}
			if(cm[iCol]!=undefined && (cm[iCol].index == 'good_img')){
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var orgImgPath = selrowContent.original_Img_Path;
				if($.trim(orgImgPath).length > 0){
					window.open("<%=Constances.SYSTEM_IMAGE_PATH%>/" + orgImgPath, '','scrollbars=yes, status=no, resizable=yes');
				}
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'good_Iden_Numb','',{color:'#0000ff',cursor: 'pointer'});
			jq("#list").setCell(rowid,'good_Name','',{color:'#0000ff',cursor: 'pointer'});   		
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			var orgImgPath = selrowContent.original_Img_Path;
			if($.trim(orgImgPath).length > 0){
				jq("#list").setCell(rowid,'good_img','',{cursor: 'pointer'});
			}
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			if(selrowContent.isUse == '0') {
				jq("#list").setCell(rowid,'full_Cate_Name','',{color:'#ff0000'});
				jq("#list").setCell(rowid,'vendorNm','',{color:'#ff0000'});
				jq("#list").setCell(rowid,'sell_Price','',{color:'#ff0000'});
			}
		},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
</script>

</head>
<body>
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">상품검색결과</td>
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
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">검색어</td>
					<td colspan="3" class="table_td_contents">
						<input type="checkbox" 	id="searchType1"	name="searchType1" 	onclick="javascript:fnSearchType('1');"/> 결과내 재검색
						<input type="checkbox" 	id="searchType2" 	name="searchType2" 	onclick="javascript:fnSearchType('2');"/> 검색어제외
						<input type="text" 		id="inputWord" 		name="inputWord" 	placeholder="검색어를 입력하세요" size="80" onblur="javascript:this.value = '';"/>
						<input type="button" 	id="totSearchbtn" 	name="totSearchbtn" value="검색" onclick="javascript:fnSearch();" />						
						<input type="hidden" 	id="prevWord" 		name="prevWord" />
					</td>
				</tr>
				
				<tr>
					<td colspan="6" class="table_top_line"></td>
				</tr>
			</table>
			<!-- 컨텐츠 끝 -->
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="right" valign="bottom">
			<a href="#">
				<img id="colButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Equipment.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
			</a>
			<a href="#">
				<img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
			</a>
		</td>
	</tr>
	<tr>
		<td>
			<div id="searchWordTxt">
				'' 검색결과
			</div>
		</td>
	</tr>
	<tr>
		<td>
			<div id="jqgrid">
				<table id="list"></table>
				<div id="pager"></div>
			</div>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display:none;">
	<p>That feature is not supported.</p>
</div>
</form>

</body>
</html>