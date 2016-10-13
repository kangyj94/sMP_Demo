<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List" %>
<%
	String listHeight = "$(window).height()-305 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";

	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	
	// 날짜 세팅
	String srcInsertStartDate = "2009-01-01";
	String srcInsertEndDate = CommonUtils.getCurrentDate();
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<script type="text/javascript">

var jq = jQuery;
$(document).ready(function() {
	initComponent();//그리드 호출
	
	codeList();//상품구분
	
	//버튼이벤트
	$("#srcButton").click(function() {
		$("#srcCateId").val($.trim($("#srcCateId").val()));
		$("#srcGoodIdenNumb").val($.trim($("#srcGoodIdenNumb").val()));
		$("#srcGoodName").val($.trim($("#srcGoodName").val()));
		fnSearch();
	});
	$('#btnSearchCategory').click(function() { fnCategoryPopOpen(); });
	$('#btnEraseCategory').click(function() { $("#srcMajoCodeName").val(''); $("#srcCateId").val(''); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });
	
	$("#srcMajoCodeName").keydown(function(e) { if(e.keyCode==13) { $("#btnSearchCategory").click(); }});	//카테고리
	$("#srcInsertStartDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//등록일
	$("#srcInsertEndDate").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//등록일
	$("#srcGoodIdenNumb").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//상품코드
	$("#srcGoodName").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});				//상품명
	$("#srcGoodClasCode").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//상품구분
	$("#srcGoodSpecDesc").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//상품규격
	$("#srcGoodSameWord").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});			//동의어
	
	
	// DataPicker 등록
	$("#srcInsertStartDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("#srcInsertEndDate").datepicker( {
		showOn: "button",
		buttonImage: "<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_calendar.gif",
		buttonImageOnly: true,
		dateFormat: "yy-mm-dd"
	});
	$("img.ui-datepicker-trigger").attr("style", "margin-left:3px; vertical-align:middle; cursor:pointer;");
	
});

//코드리스트 
function codeList(){
	//상품구분
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"ORDERGOODSTYPE",
			isUse:"1"
		},
		function(arg){
			var list = eval('('+arg+')').list;
			for(var i=0; i<list.length; i++){
				$("#srcGoodClasCode").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
			}
		}
	);
}

//그리드조회 
function fnSearch() {
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCateId = $('#srcCateId').val();
	data.srcGoodIdenNumb = $('#srcGoodIdenNumb').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcInsertStartDate = $('#srcInsertStartDate').val();
	data.srcInsertEndDate = $('#srcInsertEndDate').val();
	data.srcGoodSpecDesc = $('#srcGoodSpecDesc').val();
	data.srcGoodSameWord = $('#srcGoodSameWord').val();
	data.srcGoodClasCode = $('#srcGoodClasCode').val();
	data.srcIsUse = $('#srcIsUse').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

//엑셀 다운로드 
function exportExcel() {
	var colLabels = ['상품코드','상품명','규격','공급사','판매단가','단위','카테고리','상품구분','동의어'];	//출력컬럼명
	var colIds = ['good_Iden_Numb',	'good_Name','excelGood_Spec_Desc','vendorNm','sell_Price','orde_Clas_Code','full_Cate_Name','good_Clas_Code','good_Same_Word'];	//출력컬럼ID
	var numColIds = ['sell_Price'];	//숫자표현ID
	var figureColIds = ['good_Iden_Numb','good_Clas_Code'];
	var sheetTitle = "상품정보";	//sheet 타이틀
	var excelFileName = "GoodList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//일괄엑셀 다운
function exportExcelToSvc() {
	var colLabels = ['상품코드','상품명','규격','공급사','판매단가','단위','카테고리','상품구분','동의어1','동의어2','동의어3','동의어4','동의어5'];	//출력컬럼명
	var colIds = ['good_Iden_Numb','good_Name','excelGood_Spec_Desc','vendorNm','sell_Price','orde_Clas_Code','full_Cate_Name','good_Clas_Code','good_Same_Word1','good_Same_Word2','good_Same_Word3','good_Same_Word4','good_Same_Word5'];	//출력컬럼ID
	var numColIds = ['sell_Price'];	//숫자표현ID
	var figureColIds = ['good_Iden_Numb','good_Clas_Code'];
	var sheetTitle = "상품정보";	//sheet 타이틀
	var excelFileName = "allGoodList";	//file명
	
	var actionUrl = "/product/productListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcCateId';
	fieldSearchParamArray[1] = 'srcGoodIdenNumb';
	fieldSearchParamArray[2] = 'srcGoodName';
	fieldSearchParamArray[3] = 'srcInsertStartDate';
	fieldSearchParamArray[4] = 'srcInsertEndDate';
	fieldSearchParamArray[5] = 'srcGoodSpecDesc';
	fieldSearchParamArray[6] = 'srcGoodSameWord';
	fieldSearchParamArray[7] = 'srcGoodClasCode';
	fieldSearchParamArray[8] = 'srcIsUse';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//이미지 Error 체크 
function fnCheackErrImg(){ 
	$('img').error(function(){
		$(this).attr('src', '<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif');
	});
}

//컨퍼넌트 초기화 
function initComponent(){
	$("#srcInsertStartDate").val("<%=srcInsertStartDate%>");
	$("#srcInsertEndDate").val("<%=srcInsertEndDate%>");
	
	// 그리드 조회 
	fnInitJqGridComponent();
}
</script>

<%
   /**------------------------------------ 표준카테고리 조회 시작 ---------------------------------
    * fnSearchStandardCategoryInfo(isLastChoice,callbackString ) 을 호출하여 Div팝업을 Display ===
    * 
    * choiceCategoryLevel : 선택가능한 카테고리 레벨을 선택 한다. 
    *                        ex) "1" : 1레벨 부터 하위 래벨 선택 가능 
    *                            "2" : 2레벨 부터 하위 레벨 선택 가능 
    *                            "3" : 3레벨 부터 하위 레벨 선택 가능 
    * callbackString : 콜백 메소드 명을 기입 
    *                  파라미터 정보  (1.categoryseq ,2.카테고리명 ,3.풀카테고리명 )  
    */
%>
<%@ include file="/WEB-INF/jsp/common/product/standardCategoryInfo.jsp"%>
<script type="text/javascript">
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
   	msg += "\n categortId value ["+categortId+"]"; 
   	msg += "\n categortName value ["+categortName+"]";
   	msg += "\n categortFullName value ["+categortFullName+"]";
   	$('#srcCateId').val(categortId); 
   	$('#srcMajoCodeName').val(categortFullName); 
}	
</script>

<script type="text/javascript">
function fnInitJqGridComponent(){
	jq("#list").jqGrid({
		url:'/product/productListJQGrid.sys',
		datatype: "local",
		mtype:'POST',
		colNames:['상품코드','카테고리코드','상품명','판매가산출옵션','기준매익률','절대판매가','과거상품주문여부','공급사코드','최소주문수량','납품소요일','표준규격','상품규격',
					'이미지','공급사','엑셀규격','판매단가','단위','카테고리','상품구분','동의어','cate_Id','original_Img_Path', 'small_Img_Path' ,'공급사'],
		colModel:[
			{name:'good_Iden_Numb',index:'good_Iden_Numb',width:60,align:"left",search:false,sortable:true,editable:false },//상품코드
			{name:'cate_cd', index:'cate_cd',hidden:true,search:false},//	카테고리코드
			{name:'good_Name', index:'good_Name',width:160,align:"left",search:false,sortable:true,editable:false },//상품명
			{name:'sale_Criterion_Type', index:'sale_Criterion_Type', hidden:true,search:false},//	판매가산출옵션
			{name:'stan_Buying_Rate',index:'Stan_Buying_Rate',hidden:true,search:false},//	기준매익률
			{name:'stan_Buying_Money',index:'Stan_Buying_Money',hidden:true,search:false},//	절대판매가
			{name:'isDispPastGood', index:'isDispPastGood',hidden:true,search:false},//	과거상품주문여부
			{name:'vendorcd',index:'vendorcd',hidden:true,search:false},//	공급사 코드
			{name:'deli_Mini_Quan',index:'deli_Mini_Quan',hidden:true,search:false},//	최소주문수량
			{name:'deli_Mini_Day',index:'deli_Mini_Day',hidden:true,search:false},//	납품소요일
			{name:'good_St_Spec_Desc',index:'good_St_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//표준규격
			{name:'good_Spec_Desc',index:'good_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false },//규격
			{name:'good_img', index:'good_img',width:37,align:"center",search:false,sortable:false,editable:false },//이미지
			{name:'vendorNm',index:'vendorNm',width:100,align:'left',search:false,sortable:false,editable:false },//공급사명
			{name:'excelGood_Spec_Desc',index:'excelGood_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },//엑셀규격
			{name:'sell_Price',index:'sell_Price',width:60,align:"right",search:false,sortable:false,
				editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" } },//판매단가
			{name:'orde_Clas_Code',index:'orde_Clas_Code',width:60,align:"center",search:false,sortable:false,editable:false },//단위
			{name:'full_Cate_Name',index:'full_Cate_Name',width:240,align:'left',search:false,sortable:false,editable:false },//카테고리명
			{name:'good_Clas_Code',index:'good_Clas_Code',width:60,align:"center",search:false,sortable:false,
				editable:false,formatter:"select",editoptions:{value:"10:일반;20:지정;30:수탁;40:사급형 지입;50:사급"}},//상품구분
			{name:'good_Same_Word',index:'good_Same_Word',width:160,align:"center",search:false,sortable:false,editable:false },//동의어
			{name:'cate_Id',index:'cate_Id',hidden:true,search:false },
			{name:'small_Img_Path',index:'small_Img_Path',hidden:true,search:false },
			{name:'original_Img_Path',index:'original_Img_Path',hidden:true,search:false },
			{name:'vendorId',index:'vendorId',hidden:true,search:false }
		],
		postData: {},
		rowNum:30,rownumbers:false,rowList:[30,50,100,500],pager:'#pager',
		height:<%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'good_Name',sortorder:'Desc',
		caption:"상품정보",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,  //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
<%			for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {			%>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<%			}																				%>
			// 품목 규격 설정 
			var prodSpcNm = new Array();
<%			for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {				%>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%			}																				%>
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
				
				// img 화면 로드 
				var imgTag = ""; 
				if($.trim(selrowContent.small_Img_Path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_Img_Path+"' style='width:35px;height:35px;' />";   
				else imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_URL%>/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
				$('#list').jqGrid('setRowData',rowid,{good_img:imgTag});
				
				// 동의어 
				var good_Same_Word = selrowContent.good_Same_Word.replace(/‡/gi, " ");
				$('#list').jqGrid('setRowData',rowid,{good_Same_Word:good_Same_Word});
			}
			fnCheackErrImg(); 
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
		afterInsertRow: function(rowid, aData){},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//상품조회
	header = "상품조회";
	manualPath = "/img/manual/manage/manageProductListManual.JPG";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

</head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">상품조회
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
					<td align="right" class="ptitle" >
						<a href="#">
							<img id="excelAll" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' />
						</a>
							<img id="srcButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style=" cursor: pointer; width:65px;  height:22px;border:9px; <%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />
					</td>
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
						<input id="srcInsertStartDate" name="srcInsertStartDate" type="text" style="width: 75px;" /> ~ <input id="srcInsertEndDate" name="srcInsertEndDate" type="text" style="width: 75px;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">상품코드</td>
					<td class="table_td_contents">
						<input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="" size="" maxlength="50" />
					</td>
					<td class="table_td_subject" width="100">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodName" name="srcGoodName" type="text" value="" size="" maxlength="50" />
					</td>
					<td class="table_td_subject">상품구분</td>
					<td class="table_td_contents">
						<select id="srcGoodClasCode" name="srcGoodClasCode" style="width: 80px;" class="select">
							<option value="">전체</option>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject">상품규격</td>
					<td class="table_td_contents">
						<input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" value="" size="" maxlength="50" />
					</td>
					<td class="table_td_subject">상품동의어</td>
					<td class="table_td_contents">
						<input id="srcGoodSameWord" name="srcGoodSameWord" type="text" value="" size="" maxlength="50" />
						<input type="hidden" id="srcIsUse" name="srcIsUse" value="1" />
					</td>
<!-- 					<td class="table_td_subject">정상여부</td> -->
<!-- 					<td class="table_td_contents"> -->
<!-- 						<select id="srcIsUse" name="srcIsUse" style="width: 80px;" class="select"> -->
<!-- 							<option value="1" selected="selected">정상</option> -->
<!-- 						</select> -->

<!-- 					</td> -->
				</tr>
				<tr>
					<td colspan="6" height="1" bgcolor="eaeaea"></td>
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
</body>
</html>