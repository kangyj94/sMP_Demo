<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List" %>

<%
	//상품별 매출 현황
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-230 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	
	@SuppressWarnings("unchecked")
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");//화면권한가져오기(필수)
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);//사용자 정보
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	String srcResultFromYear = "2010";//날짜 세팅
	String srcResultFromMonth = "01";
	String srcResultToYear = CommonUtils.getCustomDay("MONTH",-1).substring(0, 4);
	String srcResultToMonth = CommonUtils.getCustomDay("MONTH",0).substring(5, 7);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//Object Event
	$('#srcButton').click( function() { fnSearch(); });
	$('#srcResultFromYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultFromMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToYear').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcResultToMonth').keydown(function(e) { if(e.keyCode==13) { $('#srcButton').click(); }});
	$('#srcBorgName').keydown(function(e) { if(e.keyCode==13) { $('#btnBuyBorg').click(); }});
	$('#srcBorgName').change(function(e) { $('#srcBorgName').val(''); $('#srcGroupId').val('0'); $('#srcClientId').val('0'); $('#srcBranchId').val('0'); });
	$('#btnBuyBorg').click(function() { fnBuyBorgSearchOpenPop(); });
	$('#srcExcelButton').click(function() { exportExcelToSvc(); });
	$('#btnSearchCategory').click(function() { fnCategoryPopOpen();});
	$('#btnEraseCategory').click(function() { $("#srcMajoCodeName").val(''); $("#srcCateId").val(''); });
	
	// 코드값 조회
	fnInitCodeData();
	
	// Component Data Bind 
	function fnInitCodeData() {
		var d = new Date();
		var currentYear = leadingZeros(d.getFullYear(), 4);
		for(var i=currentYear;i><%=srcResultFromYear%>-1;i--) {
			var strYear = i;
			$('#srcResultFromYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
			$('#srcResultToYear').append("<option value='"+strYear+"'>"+strYear+"</option>");
		}
		for(var i=1;i<13;i++) {
			var strMonth = '';
			if(i<10) { strMonth = "0"+i; } else { strMonth = i; }
			$('#srcResultFromMonth').append("<option value='"+strMonth+"'>"+strMonth+"</option>");
			$('#srcResultToMonth').append("<option value='"+strMonth+"'>"+strMonth+"</option>");
		}
		
		// 화면 초기화
		fnInitComponent();
	}
	
	// 화면 component 상태 초기화
	function fnInitComponent() {
		//실적년월
		$('#srcResultFromYear').val('<%=srcResultToYear%>');
		$('#srcResultFromMonth').val('<%=srcResultFromMonth%>');
		$('#srcResultToYear').val('<%=srcResultToYear%>');
		$('#srcResultToMonth').val('<%=srcResultToMonth%>');
		initList();	//그리드 초기화
	}
	$("#excelButton").click(function(){ exportExcel(); });
});
$(window).bind('resize', function() {
	$('#list').setGridHeight(<%=listHeight %>);
	$('#list').setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<!--------------------------- Modal Dialog Start --------------------------->
<%
	/**------------------------------------고객사팝업 사용방법---------------------------------
	* fnBuyborgDialog(borgType, isFixed, borgNm, callbackString) 을 호출하여 Div팝업을 Display ===
	* borgType : 고객사조직유형("":전체, "GRP":그룹, "CLT":법인, "BCH":사업장)
	* isFixed : 고객사조직유형 고정여부("":아니오, "1":예)
	* borgNm : 찾고자하는 고객사명
	* callbackString : 콜백함수(문자열), 콜백함수파라메타는 4개(그룹일련번호, 법인일련번호, 사업장일련번호, 조직명String) 
	*/
%>
<%@ include file="/WEB-INF/jsp/common/buyBorgListDiv.jsp"%>
<script type="text/javascript">
/**
 * 고객사 팝업 호출 
 */
function fnBuyBorgSearchOpenPop(){
	var borgNm = $('#srcBorgName').val();	
	fnBuyborgDialog('', '', borgNm, 'fnCallBackBuyBorg');
}
/**
 * 사업장 콜백
 */
function fnCallBackBuyBorg(groupId, clientId, branchId, borgNm) {
	if(groupId=='') groupId = '0';
	if(clientId=='') clientId = '0'; 
	if(branchId=='') branchId = '0'; 

	$('#srcGroupId').val(groupId);
	$('#srcClientId').val(clientId);
	$('#srcBranchId').val(branchId);
	$('#srcBorgName').val(borgNm);
}
</script>
<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
function initList() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/analysis/analysisProductListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['상품코드','대분류','중분류','소분류','상품명','주문횟수','주문수량합','매출금액','그룹Id','법인Id','사업장Id','공급사Id','총 건수의 수량 합계','금액합계'],
		colModel:[
			{ name:'good_iden_numb',index:'good_iden_numb',width:80,align:"center",search:false,sortable:true,editable:false },//상품코드
			{ name:'cate_name1',index:'cate_name1',width:100,align:"left",search:false,sortable:true,editable:false },//상품카테고리 대
			{ name:'cate_name2',index:'cate_name2',width:100,align:"left",search:false,sortable:true,editable:false },//상품카테고리 중
			{ name:'cate_name3',index:'cate_name3',width:100,align:"left",search:false,sortable:true,editable:false },//상품카테고리 소
			{ name:'good_name',index:'good_name',width:270,align:"left",search:false,sortable:true,editable:false },//상품명
			{ name:'orde_cnt',index:'orde_cnt',width:60,align:"right",search:false,sortable:true,editable:false },//주문횟수
			{ name:'orde_quan',index:'orde_quan',width:60,align:"right",search:false,sortable:true,editable:false },//주문수량합
			{ name:'sale_prod_amou',index:'sale_prod_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//매출금액
			{ name:'groupid',index:'groupid',hidden:true,search:false },//그룹Id
			{ name:'clientid',index:'clientid',hidden:true,search:false },//법인Id
			{ name:'branchid',index:'branchid',hidden:true,search:false },//사업장Id
			{ name:'vendorid',index:'vendorid',hidden:true,search:false },//공급사Id
			{ name:'sum_orde_quan',index:'sum_orde_quan',width:60,align:"right",search:false,sortable:true,editable:false,hidden:true},//총건수의 수량합계
			{ name:'sum_sale_prod_amou',index:'sum_sale_prod_amou',width:80,align:"right",search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" },hidden:true
			}//매출금액
		],
		postData: {
			srcResultFromYear:$('#srcResultFromYear').val(),
			srcResultFromMonth:$('#srcResultFromMonth').val(),
			srcResultToYear:$('#srcResultToYear').val(),
			srcResultToMonth:$('#srcResultToMonth').val(),
			srcGoodIdenNumb:$('#srcGoodIdenNumb').val(),
			srcGoodName:$('#srcGoodName').val(),
			srcCateId:$('#srcCateId').val()
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100,500,1000,3000],pager:'#pager',
		height:<%=listHeight %>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'good_name',sortorder:'desc',
		caption:"상품별 매출 현황",
		viewrecords:true,emptyrecords:'Empty records',loadonce:false,shrinkToFit:false,//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var rowCnt = $("#list").getGridParam('reccount');
			var result = "";
			if(rowCnt == 0){
				$("#total_sum_pric").html(result);
			}
			for(var idx=0; idx<rowCnt; idx++){
				var rowid = $("#list").getDataIDs()[idx];
				$("#list").restoreRow(rowid);
				var selrowContent = $("#list").jqGrid('getRowData',rowid);
				if(idx == 0){
					var total_record = fnComma(Number($("#list").getGridParam('records')));
					var tmp_sum_sale_orde_amou = fnComma(Number(selrowContent.sum_sale_prod_amou));
					var tmp_sum_orde_quan = fnComma(Number(selrowContent.sum_orde_quan));
					result = "<b>총 "+total_record+" 건의 수량합계 : " + tmp_sum_orde_quan + " 금액 합계 : "+ tmp_sum_sale_orde_amou+" 원 </b>";
					$("#total_sum_pric").html(result);
				}
			}
		},
		onSelectRow:function(rowid,iRow,iCol,e) {},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		afterInsertRow:function(rowid, aData) {},
		loadError:function(xhr,st,str) { $("#list").html(xhr.responseText); },
		jsonReader: { root:"list",page:"page",total:"total",records:"records",repeatitems:false,cell:"cell" }
	});
}
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function fnSearch() {
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcResultFromYear = $('#srcResultFromYear').val();
	data.srcResultFromMonth = $('#srcResultFromMonth').val();
	data.srcResultToYear = $('#srcResultToYear').val();
	data.srcResultToMonth = $('#srcResultToMonth').val();
	data.srcGroupId = $('#srcGroupId').val();
	data.srcClientId = $('#srcClientId').val();
	data.srcBranchId = $('#srcBranchId').val();
	data.srcGoodIdenNumb = $('#srcGoodIdenNumb').val();
	data.srcGoodName = $('#srcGoodName').val();
	data.srcCateId = $('#srcCateId').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	jq("#list").trigger("reloadGrid");
}

//사용자 함수
function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();
	if(n.length < digits) {
		for(var i = 0; i < digits - n.length; i++)
			zero += '0';
	}
	return zero + n;
}

/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = ['상품코드','대분류','중분류','소분류','상품명','공급사','주문횟수','주문수량합','매출금액','매입금액','손익금액'];	//출력컬럼명
	var colIds = ['good_iden_numb','cate_name1','cate_name2','cate_name3','good_name','vendornm','orde_cnt','orde_quan','sale_prod_amou','purc_prod_amou','prof_amou'];	//출력컬럼ID
	var numColIds = ['orde_cnt','orde_quan','sale_prod_amou','purc_prod_amou','prof_amou'];	//숫자표현ID
	var figureColIds = ['good_iden_numb','businessNum'];
	var sheetTitle = "상품별 매출 현황";	//sheet 타이틀
	var excelFileName = "analysisProductList";	//file명
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>", figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

//3자리수마다 콤마
function fnComma(n) {
	 n += '';
	 var reg = /(^[+-]?\d+)(\d{3})/;
	 while (reg.test(n)){
		 n = n.replace(reg, '$1' + ',' + '$2');
	 }
	 return n;
}

//일괄엑셀 출력
function exportExcelToSvc() {
	var colLabels = ['상품코드','대분류','중분류','소분류','상품명','공급사','주문횟수','주문수량합','매출금액','매입금액','손익금액'];	//출력컬럼명
	var colIds = ['good_iden_numb','cate_name1','cate_name2','cate_name3','good_name','vendornm','orde_cnt','orde_quan','sale_prod_amou','purc_prod_amou','prof_amou'];	//출력컬럼ID
	var numColIds = ['orde_cnt','orde_quan','sale_prod_amou','purc_prod_amou','prof_amou'];	//숫자표현ID
	var figureColIds = ['good_iden_numb','businessNum'];
	var sheetTitle = "상품별 매출 현황";	//sheet 타이틀
	var excelFileName = "analysisProductAllList";	//file명
	
	var actionUrl = "/analysis/analysisProductListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcResultFromYear';
	fieldSearchParamArray[1] = 'srcResultFromMonth';
	fieldSearchParamArray[2] = 'srcResultToYear';
	fieldSearchParamArray[3] = 'srcResultToMonth';
	fieldSearchParamArray[4] = 'srcGroupId';
	fieldSearchParamArray[5] = 'srcClientId';
	fieldSearchParamArray[6] = 'srcBranchId';
	fieldSearchParamArray[7] = 'srcVendorId';
	fieldSearchParamArray[8] = 'srcGoodIdenNumb';
	fieldSearchParamArray[9] = 'srcGoodName';
	fieldSearchParamArray[10] = 'srcCateId';

	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl, figureColIds);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
	
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
$(document).ready(function(){
	$("#question").click( function() { manageManual(); });	//메뉴얼호출
});

function manageManual(){
	var header = "";
	var manualPath = "";
	//상품별 매출 현황
	header = "상품별 매출 현황";
	manualPath = "/img/manual/manage/manageAnalysisProductListManual.JPG";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
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
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle">상품별 매출 현황
					&nbsp;<span id="question" class="questionButton">도움말</span>
				</td>
				<td align="right" class="ptitle">
					<img id="srcExcelButton" src="/img/system/btn_type3_orderResultExcel.gif" style="width:120px;height:22px;cursor:pointer;" />
					<img id="srcButton" src="/img/system/btn_type3_search.gif" style="width:65px;height:22px;cursor:pointer;" /></td>
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
				<td class="table_td_subject" width="80">실적년월</td>
				<td class="table_td_contents" width="270">
					<select id="srcResultFromYear" name="srcResultFromYear" class="select"></select>년
					<select id="srcResultFromMonth" name="srcResultFromMonth" class="select"></select>월 ~
					<select id="srcResultToYear" name="srcResultToYear" class="select"></select>년
					<select id="srcResultToMonth" name="srcResultToMonth" class="select"></select>월
				</td>
				<td class="table_td_subject" width="80">주문고객사</td>
				<td class="table_td_contents">
					<input id="srcBorgName" name="srcBorgName" type="text" value="" size="20" maxlength="50" />
					<input id="srcGroupId" name="srcGroupId" type="hidden" value="0"/>
					<input id="srcClientId" name="srcClientId" type="hidden" value="0"/>
					<input id="srcBranchId" name="srcBranchId" type="hidden" value="0"/>
					<img id="btnBuyBorg" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" style="width:20px;height:18px;border:0px;vertical-align:middle;cursor:pointer;" />
				</td>
				<td class="table_td_subject" width="80">상품카테고리</td>
				<td class="table_td_contents">
				<input id="srcMajoCodeName" name="srcMajoCodeName" type="text" value="" size="20" maxlength="30" style="width: 400px;background-color: #eaeaea;" disabled="disabled"/>
					<a href="#">
						<img id="btnSearchCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_search.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
					</a>
					<a href="#">
						<img id="btnEraseCategory" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_icon_clear.gif" class="icon_search" style="width: 20px; height: 18px; border: 0; vertical-align: middle; cursor: pointer;" />
					</a>
					<input type="hidden" id="srcCateId" name="srcCateId" value=""/>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="80">상품코드</td>
				<td class="table_td_contents">
					<input type="text" id="srcGoodIdenNumb" name="srcGoodIdenNumb" value=""/>
				</td>
				<td class="table_td_subject" width="80">상품명</td>
				<td class="table_td_contents">
					<input type="text" id="srcGoodName" name="srcGoodName" value=""/>
				</td>
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
	<td>
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top"></td>
				<td height="27px" align="right" valign="middle">
				<span id="total_sum_pric"></span>&nbsp;
					<a href="#"><img id="excelButton" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/icon/Table.gif" width="15" height="15" style='border:0;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>' /></a>
				</td>
			</tr>
		</table>
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
</table>

<!-------------------------------- Dialog Div Start -------------------------------->
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<!-------------------------------- Dialog Div End -------------------------------->
</form>
</body>
</html>