<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginRoleDto"%>
<%
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-295 + Number(gridHeightResizePlus)";
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));

	// requestParameter 
	String srcType = (String)request.getParameter("srcType") == null ? "" : (String)request.getParameter("srcType");             
	String srcProductInput = (String)request.getParameter("srcProductInput") == null ? "" : (String)request.getParameter("srcProductInput");
	String srcCateId = (String)request.getParameter("srcCateId") == null ? "" : (String)request.getParameter("srcCateId");
	String srcFullCateName = (String)request.getParameter("srcFullCateName") == null ? "" : (String)request.getParameter("srcFullCateName");
	String srcGoodName = "";
	String srcGoodIdenNumb = (String)request.getParameter("srcGoodIdenNumb") == null ? "" : (String)request.getParameter("srcGoodIdenNumb");
	String srcGoodSpecDesc = "";
	String srcGoodSameWord = "";
	String srcGoodClasCode = "";
	
	
	if(srcType.equals("productName")) srcGoodName = srcProductInput;
	else if(srcType.equals("productCode")) srcGoodIdenNumb = srcProductInput;
	
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	boolean isBuilder = false;
	for(LoginRoleDto lrd: loginUserDto.getLoginRoleList()){
		if("BUY_BUILDER".equals(lrd.getRoleCd())){
			isBuilder = true;
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!-- 버튼 이벤트 스크립트 -->
<!-------------------------------- Dialog Div Start -------------------------------->
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
<%@ include file="/WEB-INF/jsp/common/product/buyerCategoryInfo.jsp"%>
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
	$('#srcFullCateName').val(categortFullName);
	$('#srcCateId').val(categortId);
	fnSearch();
	
}
</script>
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	//Component Event 
	$("#cartAdd").click( function() { fnAddCart(); });
	$("#interestGoodAdd").click( function() { fnInterestGoodAdd(); });
	$('#srcButton').click( function() { fnSearch(); });
	$('#btnSearchCategory').click(function() { fnCategoryPopOpen(); });
	$('#btnEraseCategory').click(function() { $("#srcFullCateName").val(''); $("#srcCateId").val('0'); });
	$("#colButton").click( function() { jq("#list").jqGrid('columnChooser'); });
	$("#excelButton").click(function(){ exportExcel(); });
	$("#excelAll").click(function(){ exportExcelToSvc(); });

	//상품구분에 이미지 깜빡임 표시
	setInterval(function(){ $(".blink").fadeOut('slow').fadeIn('slow'); }, 2000);
	
	//상품검색시 엔터키로
	$("#srcGoodName ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//상품명
	$("#srcGoodIdenNumb ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//상품코드
	$("#srcCustGoodIdenNumb ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//고객사 상품코드
	$("#srcGoodSpecDesc ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//상품규격
	$("#srcGoodSameWord ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//동의어
	$("#srcVendorNm ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//공급사
	$("#srcGoodClasCode ").keydown(function(e){ if(e.keyCode==13) { $("#srcButton").click(); }});//상품구분
	
	goodClasCode();//상품구분 코드값
	
	//구매사 메인페이지 검색시 호출되는 펑션
	setTimeout(function(){ categorySearch();}, 500);
});

$(window).bind('resize', function() {
	$("#list").setGridHeight(<%=listHeight %>);
	$("#list").setGridWidth(<%=listWidth %>);
}).trigger('resize');
</script>

<%
	String listColNames = "";
	String listSellPrice = "";
	String listTotalAmout = "";
	if(!isBuilder) {
		listColNames = "'선택','상품구분','상품명','표준규격','상품규격','이미지','상품코드','공급사','상품담당자','단위','단가','수량','금액','동의어','ord_unlimit_quan','original_img_path','disp_good_id','disp_good_id2','vendorid_string','vendornm_string','the_day_post','prodStSpec1','prodStSpec2','prodStSpec3','prodStSpec4','prodStSpec5','prodStSpec6','prodSpec1','prodSpec2','prodSpec3','prodSpec4','prodSpec5','prodStSpec6','prodSpec7','prodSpec8','isDistribute','is_add_good'";
		listSellPrice = "{name:'sell_price',index:'sell_price',width:80,align:'right',search:false,sortable:true,editable:false,formatter:'integer',formatoptions:{ decimalSeparator:'', thousandsSeparator:',', decimalPlaces: 0, prefix:'' }},";
		listTotalAmout = "{name:'total_amout',index:'total_amout',width:60,align:'right',search:false,sortable:false,editable:false,formatter:'integer', formatoptions:{ decimalSeparator:'', thousandsSeparator:',', decimalPlaces: 0, prefix:'' }},";
	} else {
		listColNames = "'선택','상품구분','상품명','표준규격','상품규격','이미지','상품코드','공급사','상품담당자','단위','수량','동의어','ord_unlimit_quan','original_img_path','disp_good_id','disp_good_id2','vendorid_string','vendornm_string','the_day_post','prodStSpec1','prodStSpec2','prodStSpec3','prodStSpec4','prodStSpec5','prodStSpec6','prodSpec1','prodSpec2','prodSpec3','prodSpec4','prodSpec5','prodStSpec6','prodSpec7','prodSpec8','isDistribute','is_add_good'";
	}
%>
<script type="text/javascript">
function fnInitJqGridComponent(){
	jq("#list").jqGrid({
		url:'/product/selectBuySearchProductList/list.sys',
		editurl: "/system/getBlank.sys",
		datatype: 'local',
		mtype: 'POST',
		colNames:[<%=listColNames %>],
		colModel:[
			{name:'isCheck',index:'isCheck', width:30,align:"center",search:false,sortable:false,editable:false,
				formoptions:{rowpos:1,elmprefix:"&nbsp;&nbsp;&nbsp;&nbsp;"},formatter:checkboxFormatter},
			{name:'good_clas_code',index:'good_clas_code',width:60,align:"center",search:false,sortable:true,editable:false},//상품구분
			{name:'good_name',index:'good_name',width:200,align:"left",search:false,sortable:true,editable:false},
			{name:'good_st_spec_desc',index:'good_St_Spec_Desc',width:250,align:"left",search:false,sortable:false,editable:false,hidden:true },
			{name:'good_spec_desc',index:'good_spec_desc',width:160,align:"left",search:false,sortable:false,editable:false},//상품규격'
			{name:'small_img_path',index:'small_img_path',width:37,align:"center",search:false,sortable:false,editable:false },//이미지
			{name:'good_iden_numb',index:'good_iden_numb',width:75,align:"left",search:false,sortable:true,editable:false},//상품코드
			{name:'vendornm',index:'vendornm',width:160,align:"center",search:false,sortable:true,editable:false, formatter:selectBoxFormatter},//공급사
			{name:'product_manager',index:'product_manager',width:150,align:"center",search:false,sortable:false,editable:false },//상품담당자
			{name:'orde_clas_code',index:'orde_clas_code',width:60,align:"center",search:false,sortable:false,editable:false},//단위
			<%=listSellPrice %>	//단가
			{name:'ord_quan',index:'ord_quan', width:60,align:"right",search:false,sortable:false,editable:true,formatter:'integer', 
				formatoptions:{ decimalSeparator:'', thousandsSeparator:',', decimalPlaces: 0, prefix:'' },
				editoptions:{
					dataInit:function(elem){
						$(elem).numeric();
						$(elem).css("ime-mode", "disabled");
						$(elem).css("text-align", "right");
					},
					dataEvents:[{
						type:'change',
						fn:function(e){
							if(e.keyCode!=37 && e.keyCode!=39) {
								var rowid = (this.id).split("_")[0];
								var selrowContent = jq("#list").jqGrid('getRowData',rowid);
								var sell_price  = Number(selrowContent.sell_price);
								var ordCnt = Number(this.value);
								var limitedOrdCnt = Number(selrowContent.ord_unlimit_quan);
								var msg = ''; 
								msg += '\n sell_price value ['+sell_price+']'; 
								msg += '\n ordCnt value ['+ordCnt+']'; 
								msg += '\n limitedOrdCnt value ['+limitedOrdCnt+']'; 
								//alert(msg);
								if (ordCnt < limitedOrdCnt ){
									alert('최소 주문 수량 보다 주문수량이 작을수 없습니다.'); 
									this.value = limitedOrdCnt;
									jq("#list").restoreRow(rowid);
									jq("#list").jqGrid('setRowData', rowid, { total_amout:(sell_price*limitedOrdCnt),ord_quan:limitedOrdCnt });
									jq("#list").editRow(rowid);
								}else{
									jq("#list").jqGrid('setRowData', rowid, { total_amout:(sell_price*ordCnt) });
								}
							}
						}
					}] 
				}
			}, //수량
// 			{name:'good_inventory_cnt',index:'good_inventory_cnt',width:80, align:"right",search:false},//재고수량
			<%=listTotalAmout %> //금액
			{name:'good_same_word',index:'good_same_word',align:"left",search:false}, //good_same_word 
			{name:'ord_unlimit_quan',index:'ord_unlimit_quan',align:"center",hidden:true,search:false}, //minOrderCnt
			{name:'original_img_path',index:'original_img_path',hidden:true,search:false },	//original_img_path
			{name:'disp_good_id',index:'disp_good_id',align:"center",hidden:true,search:false,key:true},//disp_good_id
			{name:'disp_good_id2',index:'disp_good_id2',align:"center",hidden:true,search:false},//disp_good_id2
			{name:'vendorid_string',index:'vendorid_string',hidden:true,search:false },	//vendorid_string
			{name:'vendornm_string',index:'vendornm_string',hidden:true,search:false },	//vendornm_string
			{name:'the_day_post',index:'the_day_post',hidden:true,search:false},	//당일배송
			{name:'prodStSpec1',index:'prodStSpec1',hidden:true,search:false},	//규격1
			{name:'prodStSpec2',index:'prodStSpec2',hidden:true,search:false},	//규격2
			{name:'prodStSpec3',index:'prodStSpec3',hidden:true,search:false},	//규격3
			{name:'prodStSpec4',index:'prodStSpec4',hidden:true,search:false},	//규격4
			{name:'prodStSpec5',index:'prodStSpec5',hidden:true,search:false},	//규격5
			{name:'prodStSpec6',index:'prodStSpec6',hidden:true,search:false},	//규격6
			{name:'prodSpec1',index:'prodSpec1',hidden:true,search:false},	//표준규격1
			{name:'prodSpec2',index:'prodSpec2',hidden:true,search:false},	//표준규격2
			{name:'prodSpec3',index:'prodSpec3',hidden:true,search:false},	//표준규격3
			{name:'prodSpec4',index:'prodSpec4',hidden:true,search:false},	//표준규격4
			{name:'prodSpec5',index:'prodSpec5',hidden:true,search:false},	//표준규격5
			{name:'prodSpec6',index:'prodSpec6',hidden:true,search:false},	//표준규격6
			{name:'prodSpec7',index:'prodSpec7',hidden:true,search:false},	//표준규격7
			{name:'prodSpec8',index:'prodSpec8',hidden:true,search:false},	//표준규격8
			{name:'isDistribute',index:'isDistribute',hidden:true,search:false},	//isDistribute8
			{name:'is_add_good',index:'is_add_good',hidden:true,search:false}	//is_add_good
		],
		postData: {
			srcCateId:$("#srcCateId").val()
			,srcGoodName:$("#srcGoodName").val()
			,srcGoodIdenNumb:$("#srcGoodIdenNumb").val()
			,srcGoodSpecDesc:$("#srcGoodSpecDesc").val()
			,srcGoodSameWord:$("#srcGoodSameWord").val()
			,srcGoodClasCode:$("#srcGoodClasCode").val()
		},
		multiselect: false, rowNum:30, rownumbers: true, rowList:[30,50,100], pager: '#pager',
		height: <%=listHeight%>,width:$(window).width()-60 + Number(gridWidthResizePlus),
		//sortname: 'good_iden_numb', sortorder: 'asc', 
		caption:"상품조회",
		viewrecords:true, emptyrecords:'Empty records', loadonce: false, shrinkToFit:false, //해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete: function() {
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
<%	for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) {     %>
			prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<%	} %>
			var prodSpcNm = new Array();
			// 품목 규격 property 추출 
<%	for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) {     %>
			prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%	} %>
			var rowCnt = jq("#list").getGridParam('reccount');
			for(var idx=0; idx<rowCnt; idx++) {
				var rowid = $("#list").getDataIDs()[idx];
				jq("#list").restoreRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				// 규격 화면 로드
				var argStArray = selrowContent.good_st_spec_desc.split("‡");
				var argArray = selrowContent.good_spec_desc.split("‡");
				var prodStSpec = "";
				var prodSpec = "";
				for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
					if(argStArray[stIdx] > ' ') {
						prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
					}
				}
				if(prodStSpec.length > 0) {
					prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
					prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
				}
				for(var jIdx = 0 ; jIdx < prodSpcNm.length ; jIdx ++ ) {
					if($.trim(argArray[jIdx]) > ' ') {
						if(jIdx == 0 ) {
							prodSpec += "  "+ argArray[jIdx] + "  ";
						}else{
							prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
						}
					}
				}
				prodStSpec += prodSpec;
				jQuery('#list').jqGrid('setRowData',rowid,{good_spec_desc:prodStSpec});

				/*-----------------------엑셀 규격 설정 시작-----------------------*/
				
				var prodSpecArray = selrowContent.good_spec_desc.split("‡");
				var prodSpecArr = new Array();
				for(var i=0; i<prodSpecArray.length; i++){
					prodSpecArr[i] = prodSpecArray[i];
				}
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec1:prodSpecArr[0]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec2:prodSpecArr[1]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec3:prodSpecArr[2]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec4:prodSpecArr[3]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec5:prodSpecArr[4]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec6:prodSpecArr[5]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec7:prodSpecArr[6]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodSpec8:prodSpecArr[7]});
				
				var prodStSpecArray = selrowContent.good_st_spec_desc.split("‡");
				var prodStSpecArr = new Array();
				for(var i=0; i<prodStSpecArray.length; i++){
					prodStSpecArr[i] = prodStSpecArray[i];
				}
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec1:prodStSpecArr[0]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec2:prodStSpecArr[1]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec3:prodStSpecArr[2]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec4:prodStSpecArr[3]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec5:prodStSpecArr[4]});
				jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec6:prodStSpecArr[5]});
				
				/*------------------------엑셀 규격 설정 끝------------------------*/
				
				var imgTag = ""; 
				if($.trim(selrowContent.small_img_path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+selrowContent.small_img_path+"' style='width:35px;height:35px;' />";
				else imgTag = "<img src='/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
				jQuery('#list').jqGrid('setRowData',rowid,{small_img_path:imgTag});
				
				var good_same_word = selrowContent.good_same_word.replace(/‡/gi, " ");
				jQuery('#list').jqGrid('setRowData',rowid,{good_same_word:good_same_word});
				if(selrowContent.good_clas_code == "10") {
					jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"일반"});
				}else if(selrowContent.good_clas_code == "20"){
					jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"지정"});
					var goodName = "<img class='blink' src='/img/system/btn_appointment.jpg'>&nbsp;"+selrowContent.good_name;
					jq("#list").jqGrid('setRowData', rowid, {good_name:goodName});
				}else if(selrowContent.good_clas_code == "30"){
					jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"수탁"});
				}else if(selrowContent.good_clas_code == "40"){
					jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"사급형 지입"});
				}else if(selrowContent.good_clas_code == "50"){
					jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"사급"});
				}
				if(selrowContent.the_day_post == 1){
					var goodInventoryCnt = "<font color='red' class='blink'>당일발송</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+selrowContent.good_inventory_cnt;
					jq("#list").jqGrid('setRowData', rowid, {good_inventory_cnt:goodInventoryCnt});
				}
			}
		},
		onCellSelect:function(rowid,iCol,cellcontent,target) {
			var cm = $("#list").jqGrid('getGridParam','colModel');
			if(cm[iCol]!=undefined && (cm[iCol].index == 'good_name' )){
				var mstDatas = $("#list").jqGrid('getRowData',rowid);
				fnProductDetailForBuyer(mstDatas['disp_good_id2']);
			}
			if(cm[iCol]!=undefined && (cm[iCol].index == 'small_img_path')){
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				var orgImgPath = selrowContent.original_img_path;
				if($.trim(orgImgPath).length > 0){
					window.open("<%=Constances.SYSTEM_IMAGE_PATH%>/" + orgImgPath, '','scrollbars=yes, status=no, resizable=yes');
				}
			}
		},
		afterInsertRow: function(rowid, aData){
			jq("#list").setCell(rowid,'good_name','',{color:'#0000ff',cursor: 'pointer'});
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			jq("#list").jqGrid('setRowData', rowid, {disp_good_id2:selrowContent.disp_good_id});
			jq("#list").jqGrid('setRowData', rowid, {total_amout:selrowContent.sell_price*selrowContent.ord_quan});
			
			var isDistribute = selrowContent.isDistribute;
// 			if(isDistribute == 0) {	//10000005902 상품에 대해서 물량배분을 해도 공급사가 보이도록 설정해 달라고 함(진영준대리 요청 20150805)
			if(isDistribute == 0 || (isDistribute!=0 && selrowContent.is_add_good=='1')) {
				/*----------------------중복제거 시작--------------------------*/
				var vendorid_array = aData.vendorid_string.split("|");
				var vendornm_array = aData.vendornm_string.split("|");
				var chg_vendorid_string = "";
				var chg_vendornm_string = "";
				if(vendorid_array.length>1) {
					vendorid_array = removeArrayDuplicate(vendorid_array);
					vendornm_array = removeArrayDuplicate(vendornm_array);
					for(var i=0;i<vendorid_array.length;i++) {
						if(i==0) {
							chg_vendorid_string = vendorid_array[i];
							chg_vendornm_string = vendornm_array[i];
						} else {
							chg_vendorid_string += "|" + vendorid_array[i];
							chg_vendornm_string += "|" + vendornm_array[i];
						}
					}
					jq("#list").jqGrid('setRowData', rowid, {vendorid_string:chg_vendorid_string});
					jq("#list").jqGrid('setRowData', rowid, {vendornm_string:chg_vendornm_string});
				}
				/*----------------------중복제거 끝--------------------------*/
			} else {
				var vendorid_array = aData.vendorid_string.split("|");
				jq("#list").jqGrid('setRowData', rowid, {vendorid_string:vendorid_array[0], vendornm_string:'SK텔레시스', vendornm:'SK텔레시스'});
// 				jq("#list").jqGrid('setRowData', rowid, {vendornm_string:'SK텔레시스'});
// 				jq("#list").jqGrid('setRowData', rowid, {vendornm:'SK텔레시스'});
			}
		},
		ondblClickRow: function (rowid, iRow, iCol, e) {},
		loadError : function(xhr, st, str){ $("#list").html(xhr.responseText); },
		jsonReader : {root: "list",page: "page",total: "total",records: "records",repeatitems: false,cell: "cell"}
	});
}
/**
 * Array 중복제거함수
 */
function removeArrayDuplicate(arr) {
	for(var i=0; i<arr.length; i++) {
		var checkDobl = 0;
		for(var j=0; j<arr.length; j++) {
			if(arr[i] != arr[j]) {
				continue;
			} else {      
				checkDobl++;
				if(checkDobl>1){
					spliced = arr.splice(j,1);
				}
			}
		}
	}
	return arr;
}

/**
 * 조회버튼 클릭시 발생 이벤트 
 */
function fnSearch(){
// 	var srcObj = new Object(); 
// 	alert(000);
// 	srcObj['srcCateId']         =   $('#srcCateId').val();
// 	srcObj['srcGoodName']       =   $('#srcGoodName').val();
// 	srcObj['srcGoodIdenNumb']   =   $('#srcGoodIdenNumb').val();
// 	srcObj['srcGoodSpecDesc']   =   $('#srcGoodSpecDesc').val();
// 	srcObj['srcGoodSameWord']   =   $('#srcGoodSameWord').val();
// 	srcObj['srcVendorNm']       =   $('#srcVendorNm').val();
// 	srcObj['srcGoodClasCode']      =   $('#srcGoodClasCode').val();
// 	jq("#list").jqGrid("setGridParam", {"page":1});
// 	jq("#list").jqGrid("setGridParam", { "postData": srcObj });
// 	jq("#list").trigger("reloadGrid");
	
	jq("#list").jqGrid("setGridParam", {"page":1});
	var data = jq("#list").jqGrid("getGridParam", "postData");
	data.srcCateId = $('#srcCateId').val();
	data.srcGoodName =   $('#srcGoodName').val();
	data.srcGoodIdenNumb =   $('#srcGoodIdenNumb').val();
	data.srcGoodSpecDesc  =   $('#srcGoodSpecDesc').val();
	data.srcGoodSameWord =   $('#srcGoodSameWord').val();
	data.srcVendorNm =   $('#srcVendorNm').val();
	data.srcGoodClasCode =   $('#srcGoodClasCode').val();
	jq("#list").jqGrid("setGridParam", { "postData": data });
	$("#list").jqGrid("setGridParam",{datatype:"json"}).trigger("reloadGrid");
}

</script>
<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
/**
 * 공급사 Select Box(우선순위(vendro_priority) 공급사를 맨 위로 두고 순서대로 select box로 나타낸다.) 2014-05-20 비트큐브 임상건
 */
 function selectBoxFormatter(cellvalue, options, rowObject) {
	var vendoridAr = new Array();
	var vendornmAr = new Array();
	vendoridAr = (rowObject.vendorid_string).split('|');
	vendornmAr = (rowObject.vendornm_string).split('|');
	vendoridAr = removeArrayDuplicate(vendoridAr);
	vendornmAr = removeArrayDuplicate(vendornmAr);
	var tmpStr = "";
// 	if(vendoridAr.length>1) {
		tmpStr = "<select id='buyi_vendor_code_" + options.rowId + "' name='buyi_vendor_code_" + options.rowId + "' class='select' style='width:150px;' title='' onchange=\"javaScript:onChangeVendorm('"+options.rowId+"');\">";
		for(var i=0; i<vendoridAr.length; i++){
			tmpStr += "<option value='" + vendoridAr[i] +"' >" + vendornmAr[i] + "</option>";
		}
		tmpStr += "</select>";
// 	} else {
// 		tmpStr = vendornmAr;
// 	}
	return tmpStr;
}
 /**
  * 공급사 Select Box에서 선택한 공급사에 맞는 상품 항목들을 변경 한다. 2014-05-20 비트큐브 임상건
  */
function onChangeVendorm(rowid){
	var selrowContent = jq("#list").jqGrid('getRowData', rowid);
	var good_iden_numb = selrowContent.good_iden_numb;
	var vendorid = $("select[name=buyi_vendor_code_"+rowid+"]").val();
	$.post(
		"/product/selectBuySearchProductCombo/buyProductDto/object.sys",
		{ good_iden_numb:good_iden_numb, vendorid:vendorid }
		,function(arg){ 
			var result = eval('(' + arg + ')').buyProductDto;
			/*--------------------------규격 설정 시작--------------------------*/
			var good_st_spec_desc = result.good_st_spec_desc;
			var good_spec_desc = result.good_spec_desc;
			// 품목 표준 규격 설정
			var prodStSpcNm = new Array();
<%	for(int idx = 0 ; idx < Constances.PROD_GOOD_ST_SPEC.length ; idx++) { %>
				prodStSpcNm.push('<%= Constances.PROD_GOOD_ST_SPEC[idx]%>');
<%	} %>
			// 품목 규격 property 추출
			var prodSpcNm = new Array();
<%	for(int idx = 0 ; idx < Constances.PROD_GOOD_SPEC.length ; idx++) { %>
				prodSpcNm.push('<%= Constances.PROD_GOOD_SPEC[idx]%>');
<%	} %>
			// 규격 화면 로드
			var argStArray = good_st_spec_desc.split("‡");
			var argArray = good_spec_desc.split("‡");
			var prodStSpec = "";
			var prodSpec = "";
			for(var stIdx = 0 ; stIdx < prodStSpcNm.length ; stIdx ++ ) {
				if(argStArray[stIdx] > ' ') {
					prodStSpec += prodStSpcNm[stIdx]+":"+ argStArray[stIdx] + " X ";
				}
			}
			if(prodStSpec.length > 0) {
				prodStSpec = prodStSpec.substring(0,prodStSpec.length-3);
				prodStSpec = "<font color='red'>["+ prodStSpec + "]</font>";
			}
			for(var jIdx = 0 ; jIdx < prodSpcNm.length; jIdx ++ ) {
				if($.trim(argArray[jIdx]) > ' ') {
					if(jIdx == 0 ) prodSpec += "  "+ argArray[jIdx] + "  ";
					else prodSpec += prodSpcNm[jIdx]+":"+ argArray[jIdx] + " ";
				}
			}
			prodStSpec += prodSpec;
			/*--------------------------규격 설정 끝--------------------------*/
			
			/*-----------------------엑셀 규격 설정 시작-----------------------*/
			
			var prodSpecArray = good_spec_desc.split("‡");
			var prodSpecArr = new Array();
			for(var i=0; i<prodSpecArray.length; i++){
				prodSpecArr[i] = prodSpecArray[i];
			}
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec1:prodSpecArr[0]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec2:prodSpecArr[1]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec3:prodSpecArr[2]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec4:prodSpecArr[3]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec5:prodSpecArr[4]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec6:prodSpecArr[5]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec7:prodSpecArr[6]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodSpec8:prodSpecArr[7]});
			
			var prodStSpecArray = good_st_spec_desc.split("‡");
			var prodStSpecArr = new Array();
			for(var i=0; i<prodStSpecArray.length; i++){
				prodStSpecArr[i] = prodStSpecArray[i];
			}
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec1:prodStSpecArr[0]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec2:prodStSpecArr[1]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec3:prodStSpecArr[2]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec4:prodStSpecArr[3]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec5:prodStSpecArr[4]});
			jQuery('#list').jqGrid('setRowData',rowid,{prodStSpec6:prodStSpecArr[5]});
			
			/*------------------------엑셀 규격 설정 끝------------------------*/
			
			/*--------------------------이미지,동의서 설정 시작--------------------------*/
			var imgTag = ""; 
			if($.trim(result.small_img_path) > ' ') imgTag = "<img src='<%=Constances.SYSTEM_IMAGE_PATH%>/"+result.small_img_path+"' style='width:35px;height:35px;' />";   
			else imgTag = "<img src='/img/system/imageResize/prod_img_50.gif' style='width:35px;height:35px;' />";
			var good_same_word = result.good_same_word.replace(/‡/gi, " ");
			var totalAmout = result.deli_mini_quan * result.sell_price;
			/*--------------------------이미지,동의서 설정 끝--------------------------*/

			jq("#list").setSelection(rowid);
			jq("#list").jqGrid('setRowData', rowid, {vendornm:result.vendornm});
			jq("#list").jqGrid('setRowData', rowid, {disp_good_id2:result.disp_good_id});
			jq("#list").jqGrid('setRowData', rowid, {sell_price:result.sell_price});
			jq("#list").jqGrid('setRowData', rowid, {ord_quan:result.ord_quan});
			jq("#list").jqGrid('setRowData', rowid, {deli_mini_quan:result.deli_mini_quan});
			jq("#list").jqGrid('setRowData', rowid, {orde_clas_code:result.orde_clas_code});
			jq("#list").jqGrid('setRowData', rowid, {original_img_path:result.original_img_path});
			jq("#list").jqGrid('setRowData', rowid, {good_spec_desc:prodStSpec});
			jq("#list").jqGrid('setRowData', rowid, {small_img_path:imgTag});
			jq("#list").jqGrid('setRowData', rowid, {good_same_word:good_same_word});
			jq("#list").jqGrid('setRowData', rowid, {total_amout:totalAmout});
			jq("#list").jqGrid('setRowData', rowid, {the_day_post:result.the_day_post});
			if(result.orde_clas_code == "10") {
				jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"일반", good_name:selrowContent.good_name});
			}else if(result.orde_clas_code == "20"){
				var goodName = "<img class='blink' src='/img/system/btn_appointment.jpg'>&nbsp;"+selrowContent.good_name;
				jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"지정", good_name:goodName});
			}else if(result.orde_clas_code == "30"){
				jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"수탁", good_name:selrowContent.good_name});
			}else if(result.orde_clas_code == "40"){
				jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"사급형 지입", good_name:selrowContent.good_name});
			}else if(result.orde_clas_code == "50"){
				jq("#list").jqGrid('setRowData', rowid, {good_clas_code:"사급", good_name:selrowContent.good_name});
			}
			if(result.the_day_post == 1){
				var goodInventoryCnt = "<font color='red' class='blink'>당일발송</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+result.good_inventory_cnt;
				jq("#list").jqGrid('setRowData', rowid, {good_inventory_cnt:goodInventoryCnt});
			}else{
				var goodInventoryCnt = result.good_inventory_cnt;
				jq("#list").jqGrid('setRowData', rowid, {good_inventory_cnt:goodInventoryCnt});
			}
			if($("input:checkbox[id='isCheck_"+rowid+"']").is(":checked") == true){
				jq("#list").editRow(rowid);
			}
		}
	);
}

/**
 * list 체크박스 포맷제공
 */
function checkboxFormatter(cellvalue, options, rowObject) {
	return "<input id='isCheck_"+options.rowId+"' name='isCheck_"+options.rowId+"' type='checkbox' style='border: 0' onclick=\"fnChangeEdit(this , '" + options.rowId + "', this);\" offval='no' />";
}
/**
 * list 체크박스 클릭 시 EditRow
 */
function fnChangeEdit(obj , rowid, object) {	
	if(object.checked) {
		jq("#list").setSelection(rowid);
		jq("#list").editRow(rowid);
	} else {
		jq("#list").restoreRow(rowid);
		jq("#list").setSelection(rowid);
	}
}
// 선택 버튼 클릭시 발생 이벤트 
function fnAddCart(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		var arrRowIdx = 0 ;
		var disp_good_id_Array = new Array(); 
		var ord_quan_Array = new Array();
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			if (jq("#isCheck_"+rowid).attr("checked")) {
				jq('#list').saveRow(rowid);
				var selrowContent = jq("#list").jqGrid('getRowData',rowid);
				disp_good_id_Array[arrRowIdx] = selrowContent.disp_good_id2; 
				ord_quan_Array[arrRowIdx] = selrowContent.ord_quan;
				arrRowIdx++;
			}
		}
		var msg = ''; 
		for (var i = 0 ; i < disp_good_id_Array.length ; i ++ ) msg += '\n ['+disp_good_id_Array[i]+']';
		if (arrRowIdx == 0 ) {
			jq( "#dialogSelectRow" ).dialog();
			return; 
		}
		if(!confirm("선택상품을 장바구니에 담으시겠습니까?")) return;
		$.post(
			"/order/cart/addProductInCartTransGrid.sys",
			{ disp_good_id_Array:disp_good_id_Array , ord_quan_Array:ord_quan_Array }
			,function(arg){ 
				if(fnTransResult(arg, false)) {    //성공시
					if(!confirm("장바구니 페이지로 이동하시겠습니까?")) {
						jq("#list").trigger("reloadGrid");
					}else {
						fnGoCartPage();
					}
				}
			}
		);
	}
}

/**
 * 관심품목 등록 
 */
function fnInterestGoodAdd(){
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt == 0 ) {
		$('#dialogSelectRow').html('<p>선택된 상품 정보가 없습니다. \n확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog();
		return; 
	}
	var arrayCnt = 0 ; 
	var disp_good_id_array = new Array();
	for(var idx=0; idx<rowCnt; idx++){
		var rowIdx = $("#list").getDataIDs()[idx];
		if($("#isCheck_"+rowIdx).attr("checked")){
			isCheak = true; 
			var selrowContent = jq("#list").jqGrid('getRowData',rowIdx);
			disp_good_id_array[arrayCnt] = selrowContent.disp_good_id2;
			arrayCnt++; 
		}
	}
	if(arrayCnt==0) { 
		$('#dialogSelectRow').html('<p>선택된 상품 정보가 없습니다. \n확인후 이용하시기 바랍니다.</p>');
		$("#dialogSelectRow").dialog(); 
		return; 
	}
	$.post(
		"/product/addInterestProductTransGrid.sys", 
		{ disp_good_id_array:disp_good_id_array },
		function(arg){
			if(fnTransResult(arg, false)) { //성공시
				// 관심품목 페이지로 이동 
				if(confirm("관심상품 페이지로 이동하시겠습니까?")) {
					fnGoInterestProduct(); 
				}else {
					jq("#list").trigger("reloadGrid");  
				}  
			}
		}
	);
}

<%
	String excelColLabels = "";
	String excelColIds = "";
	String excelNumColIds = "";
	if(!isBuilder) {
		
// 		excelColLabels = "'상품구분','상품명','상품규격','상품코드','공급사','상품담당자','단위','단가','수량','재고수량'";
		excelColLabels = "'상품구분','상품명','Ø','W','D','H','L','t','규격','제질','크기','총중량(할증포함)','색상','TYPE','실중량kg','M(미터)','상품코드','공급사','상품담당자','단위','단가','수량'";
		excelColIds = "'good_clas_code','good_name','prodStSpec1','prodStSpec2','prodStSpec3','prodStSpec4','prodStSpec5','prodStSpec6','prodSpec1','prodSpec2','prodSpec3','prodSpec4','prodSpec5','prodSpec6','prodSpec7','prodSpec8','good_iden_numb','vendornm','product_manager','orde_clas_code','sell_price','ord_quan'";
		excelNumColIds = "'sell_price','ord_quan'";
	} else {
// 		excelColLabels = "'상품구분','상품명','상품규격','상품코드','공급사','상품담당자','단위','수량','재고수량'";
		excelColLabels = "'상품구분','상품명','Ø','W','D','H','L','t','규격','제질','크기','총중량(할증포함)','색상','TYPE','실중량kg','M(미터)','상품코드','공급사','상품담당자','단위','수량'";
		excelColIds = "'good_clas_code','good_name','prodStSpec1','prodStSpec2','prodStSpec3','prodStSpec4','prodStSpec5','prodStSpec6','prodSpec1','prodSpec2','prodSpec3','prodSpec4','prodSpec5','prodSpec6','prodSpec7','prodSpec8','good_iden_numb','vendornm','product_manager','orde_clas_code','ord_quan'";
		excelNumColIds = "'ord_quan'";
	}
%>
/**
 * list Excel Export
 */
function exportExcel() {
	var colLabels = [<%=excelColLabels %>];	//출력컬럼명
	var colIds = [<%=excelColIds %>];  //출력컬럼ID
	var numColIds = [<%=excelNumColIds %>];    //숫자표현ID
	var sheetTitle = "상품검색결과";  //sheet 타이틀
	var excelFileName = "ProductList";  //file명
	/*---------------------엑셀출력 체크박스 제한-----------------------*/
	var rowCnt = jq("#list").getGridParam('reccount');
	if(rowCnt>0) {
		for(var i=0; i<rowCnt; i++) {
			var rowid = $("#list").getDataIDs()[i];
			var isCheckList = jq("#isCheck_"+rowid).attr("checked");
			if(isCheckList) {
				alert("엑셀 출력은 체크박스을 해제하시고 수행하십시오!");
				return;
			}
		}
	}
	fnExportExcel(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "");    //Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

function exportExcelToSvc() {
	var colLabels = ['상품명','상픔구분','상품규격','상품코드','공급사','상품담당자','단위'<%if(!isBuilder){%>,'단가'<%}%>,'수량'<%if(!isBuilder){%>,'금액'<%}%>];          //출력컬럼명
	var colIds = ['good_name','good_clas_code','good_spec_desc','good_iden_numb','borgnm','product_manager','orde_clas_code'<%if(!isBuilder){%>,'sell_price'<%}%>,'ord_quan'<%if(!isBuilder){%>,'total_amout'<%}%>];  //출력컬럼ID
<%-- 	var colLabels = ['상품명','상픔구분','Ø','W','D','H','L','t','규격','제질','크기','총중량(할증포함)','색상','TYPE','실중량kg','M(미터)','상품코드','공급사','상품담당자','단위'<%if(!isBuilder){%>,'단가'<%}%>,'수량'<%if(!isBuilder){%>,'금액'<%}%>];          //출력컬럼명 --%>
<%-- 	var colIds = ['good_name','good_clas_code','good_st_spec_desc1','good_st_spec_desc2','good_st_spec_desc3','good_st_spec_desc4','good_st_spec_desc5','good_st_spec_desc6','good_spec_desc1','good_spec_desc2','good_spec_desc3','good_spec_desc4','good_spec_desc5','good_spec_desc6','good_spec_desc7','good_spec_desc8','good_iden_numb','borgnm','product_manager','orde_clas_code'<%if(!isBuilder){%>,'sell_price'<%}%>,'ord_quan'<%if(!isBuilder){%>,'total_amout'<%}%>];  //출력컬럼ID --%>

	var numColIds = [<%if(!isBuilder){%>'sell_price',<%}%>'ord_quan'<%if(!isBuilder){%>,'total_amout'<%}%>];    //숫자표현ID
	var sheetTitle = "상품검색결과";  //sheet 타이틀
	var excelFileName = "ProductList";  //file명
	
	var actionUrl = "/product/buyProductListExcel.sys";
	var fieldSearchParamArray = new Array();
	fieldSearchParamArray[0] = 'srcCateId';
	fieldSearchParamArray[1] = 'srcGoodName';
	fieldSearchParamArray[2] = 'srcGoodIdenNumb';
	fieldSearchParamArray[3] = 'srcCustGoodIdenNumb';
	fieldSearchParamArray[4] = 'srcGoodSpecDesc';
	fieldSearchParamArray[5] = 'srcGoodSameWord';
	fieldSearchParamArray[6] = 'srcPopularityProduct';
	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "<%=Constances.SYSTEM_CONTEXT_PATH %>",fieldSearchParamArray, actionUrl);	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
}

// function exportExcelToSvc() {
<%-- 	var colLabels = [<%=excelColLabels %>];	//출력컬럼명 --%>
<%-- 	var colIds = [<%=excelColIds %>];  //출력컬럼ID --%>
<%-- 	var numColIds = [<%=excelNumColIds %>]; //숫자표현ID --%>
// 	var sheetTitle = "상품검색결과";  //sheet 타이틀
// 	var excelFileName = "ProductList";  //file명
// 	//var actionUrl = "/product/buyProductListExcel.sys";
	
// 	var fieldSearchParamArray = new Array();
// 	fieldSearchParamArray[0] = 'srcCateId';
// 	fieldSearchParamArray[1] = 'srcGoodName';
// 	fieldSearchParamArray[2] = 'srcGoodIdenNumb';
// 	fieldSearchParamArray[3] = 'srcGoodSpecDesc';
// 	fieldSearchParamArray[4] = 'srcGoodSameWord';
// 	fieldSearchParamArray[5] = 'srcGoodClasCode';
// 	fnExportExcelToSvc(jq("#list"), colLabels, colIds, numColIds, sheetTitle, excelFileName, "",fieldSearchParamArray, "");	//Grid Object, 컬럼레벨배열, 컬럼ID배열, 숫자표현ID배열, sheet 타이틀, file명
// }

/**
 * 상품 상세  
 */
function fnProductDetailForBuyer(disp_good_id){
	fnCustProductDetailView('<%=menuId%>', disp_good_id);   
}

/**
 * 장바구니 페이지로 이동 
 */
function fnGoCartPage() {
	$('#frm').attr('action','/order/cart/cartMstInfo.sys');
	$('#frm').attr('Target','_self');
	$('#frm').attr('method','post');
	$('#frm').submit();
}

/**
 * 관심상품 페이지로 이동  
 */
function fnGoInterestProduct(){
	$('#frm').attr('action','/product/buyWishList.sys');
	$('#frm').attr('Target','_self');
	$('#frm').attr('method','post');
	$('#frm').submit(); 
} 
/**
 * 주문 리스트 페이지로 이동 
 */
function fnGoOrderList(){
	$('#frm').attr('action','/order/orderRequest/orderList.sys');
	$('#frm').attr('Target','_self');
	$('#frm').attr('method','post');
	$('#frm').submit(); 
}

/**
 * 상품구분
 */
function goodClasCode(){
	$.post(
		"/common/etc/selectCodeList/list.sys",
		{
			codeTypeCd:"ORDERGOODSTYPE",
			isUse:"1"
		},
		function(arg){
			var goodClasCodeList = eval('('+arg+')').list;
			for(var i=0; i<goodClasCodeList.length; i++){
				$("#srcGoodClasCode").append("<option value="+goodClasCodeList[i].codeVal1+">"+goodClasCodeList[i].codeNm1+"</option>");
			}
			//그리드호출
			fnInitJqGridComponent();
		}
	);
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("#question").click( function() { branchManual(); });	//메뉴얼호출
});

function branchManual(){
	var header = "고객사 상품조회";
	var manualPath = "/img/manual/branch/buyProductSearchPriority.jpg";
	var popUrl = "/system/manual.sys?header="+header+"&manualPath="+manualPath;
	window.open(popUrl, 'okplazaPop', 'width=1050, height=800, scrollbars=yes, status=no, resizable=no');
}
</script>

<script type="text/javascript">

//구매사 메인페이지 검색시 호출되는 펑션
function categorySearch(){
	if($("#srcCateId").val() != "" && $("#srcFullCateName").val() != ""){
		fnSearch();
	}else if($("#srcGoodName").val() != ""){
		fnSearch();
	}else if($("#srcGoodIdenNumb").val() != ""){
		fnSearch();
	}
}
</script>
</head>
<body>
<form id="frm" name="frm">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="/img/system/bullet_ptitle1.gif" width="14" height="15" />
					</td>
					<td height="29" class='ptitle'>고객사상품조회
						&nbsp;<span id="question" class="questionButton">도움말</span>
					</td>
					<td align="right" class='ptitle'>
						<a href="#"><img id="excelAll" src="/img/system/btn_type3_orderResultExcel.gif" height="22" style='border:0;vertical-align: middle;' /></a>
						<a href="#"><img id="srcButton" src="/img/system/btn_type3_search.gif" width="65" height="22" style='border: 0; vertical-align: middle;' /></a>
					</td>
				</tr>
			</table>
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
					<td class="table_td_subject" width="100">카테고리</td>
					<td class="table_td_contents" colspan="5">
						<input id="srcFullCateName" name="srcFullCateName" type="text" value="<%=srcFullCateName %>" size="20" maxlength="30" style="width: 400px; width: 60%; background-color: #eaeaea;" disabled="disabled" />
						<input id="srcCateId" name="srcCateId" type="hidden" readonly="readonly" value="<%=srcCateId%>"/>
						<img id="btnSearchCategory" src="/img/system/btnCategorySearch.gif" class="icon_search" style="border: 0; vertical-align: middle; cursor: pointer;" />
						<img id="btnEraseCategory" src="/img/system/btnBegin.gif" class="icon_search" style="border: 0; vertical-align: middle; cursor: pointer;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">상품명</td>
					<td class="table_td_contents">
						<input id="srcGoodName" name="srcGoodName" type="text" value="<%=srcGoodName %>" style="width: 80%;" />
					</td>
					<td class="table_td_subject" width="100">상품코드</td>
					<td class="table_td_contents">
						<input id="srcGoodIdenNumb" name="srcGoodIdenNumb" type="text" value="<%=srcGoodIdenNumb %>" style="width: 80%;" />
					</td>
					<td class="table_td_subject" width="100">상품규격</td>
					<td class="table_td_contents">
						<input id="srcGoodSpecDesc" name="srcGoodSpecDesc" type="text" style="width: 80%;" />
					</td>
				</tr>
				<tr>
					<td colspan="6" height='1' bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td width="80" class="table_td_subject">동의어</td>
					<td class="table_td_contents">
						<input id="srcGoodSameWord" name="srcGoodSameWord" type="text" style="width: 80%;" />
					</td>
					<td width="80" class="table_td_subject">공급사</td>
					<td class="table_td_contents" style="text-align: left; vertical-align: middle;">
						<input id="srcVendorNm" name="srcVendorNm" type="text" style="width: 80%;" />
					</td>
					<td width="80" class="table_td_subject">상품구분</td>
					<td class="table_td_contents" style="text-align: left; vertical-align: middle;">
						<select id="srcGoodClasCode" style="width: 30%;">
							<option value="">전체</option>
						</select>
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
		<td align="right">
			<img id="cartAdd" src="/img/system/btn_type1_cartAdd1.gif" width="105" height="22" style="cursor: pointer;" />
<%	if(!isBuilder){	%>
			<img id="interestGoodAdd" src="/img/system/btn_type1_cartAdd2.gif" width="98" height="22" style="cursor: pointer;" />
<%	}	%>
			<img id="colButton" src="/img/system/icon/Equipment.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
			<img id="excelButton" src="/img/system/icon/Table.gif" width="15" height="15" style='border: 0; cursor: pointer;' />
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
</form>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>
<div id="dialog" title="Feature not supported" style="display: none;">
	<p>That feature is not supported.</p>
</div>
</body>
</html>