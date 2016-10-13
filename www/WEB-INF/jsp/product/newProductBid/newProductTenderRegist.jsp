<%@page import="kr.co.bitcube.common.dto.CodesDto"%>
<%@page import="kr.co.bitcube.system.dao.CodeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@ page import="java.util.List"%>

<%
	//그리드의 width와 Height을 정의
	int listHeight = 100;
	String listWidth = "$(window).width()-60 + Number(gridWidthResizePlus)";
	
	String strTitle = "";
	String vendornmAuc = "";
	String vendoridAuc = "";
	String bidding_user_idAuc = "";
	String popupClose = "false";
	
	String bidstate = CommonUtils.getString((String)request.getAttribute("bidstate"));
	
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME); //사용자 정보
	if("ADM".equals(loginUserDto.getSvcTypeCd())) {
		strTitle = "입찰생성";
	} else {
		strTitle = "입찰생성 (투찰)";
		vendornmAuc = loginUserDto.getBorgNm();
		vendoridAuc = loginUserDto.getBorgId();
		bidding_user_idAuc = loginUserDto.getUserId();
		popupClose = "true";
	}
	
	//메뉴Id
	String menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	
	String bidding_dateAuc = CommonUtils.getCurrentDate();// 날짜 세팅
	String bidid = ( (String)request.getAttribute("bidid") == null ) ? "" : (String)request.getAttribute("bidid");// 상품입찰 공고 ID
	String vendorbidstate = ( (String)request.getAttribute("vendorbidstate") == null ) ? "" : (String)request.getAttribute("vendorbidstate");// 투찰,낙찰 상태
	
	String businessNum = "";
	String registNum = "";
	
	if(loginUserDto.getSmpVendorsDto() != null){
		businessNum = CommonUtils.getString(loginUserDto.getSmpVendorsDto().getBusinessNum());	
		registNum = CommonUtils.getString(loginUserDto.getSmpVendorsDto().getRegistNum());	
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<% 	if(Constances.COMMON_ISREAL_SERVER && !"".equals(businessNum)) { %>
<%
/**------------------------------------공인인증 등록---------------------------------
  파라미터1 : 법인 (CLT), 공급사 (VEN)
  파라미터2 : 사용구분 (REG : 업체등록, ETC : 기타)
  파라미터3 : 공인인증서 인증상태 (0 : 등록, 1 : 생성, 2 : 무시), 공통함수사용
  파라미터4 : 사업자 등록번호 (인증상태값이 1인 경우에만 사용한다. 1이 아닌경우 '' 으로 넘긴다.)
  파라미터5 : CallBack function명
  파라미터6 : 조직ID (법인일경우 ClientId, 사업장일경우 VendorId) 
*/
%>
<%@ include file="/WEB-INF/jsp/common/auth/authBusinessNumberDiv.jsp" %>
<script type="text/javascript">
var authStep = "";
function fnAuth(){
	if($.trim($("#is_use_certificate").val()) == "1"){
		//fnGetIsExistPublishAuth(svcTypeCd, borgId) - 현재 세션의 공인인증서 인증상태를 확인 (파라미터3 참조)
		authStep = fnGetIsExistPublishAuth('<%=loginUserDto.getSvcTypeCd()%>','<%=loginUserDto.getBorgId()%>');
		fnAuthBusinessNumberDialog("VEN", "ETC", authStep, '<%=businessNum%>',"fnCallBackAuthBusinessNumber", '<%=loginUserDto.getBorgId()%>');
	}else if($.trim($("#is_use_certificate").val()) == "0"){
		tenNewProduct('stop');
	}
}

function fnCallBackAuthBusinessNumber(userDn) {
	if((userDn != "" && userDn != null) || authStep == "2"){
		tenNewProduct('stop');
	}
}
</script>
<%	}else{ %>
<script type="">
function fnAuth(){
	tenNewProduct('stop');
}
</script>
<%	} %>
<% //------------------------------------------------------------------------------ %>

<!--------------------------- jQuery Fileupload --------------------------->
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/ajaxupload.3.5.js" type="text/javascript"></script>
<script type="text/javascript" src="<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/js/HuskyEZCreator.js" charset="utf-8"></script>

<!-- file Upload 스크립트 -->
<script type="text/javascript">
var oEditors = [];
$(function() {
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "tx_load_content",
		sSkinURI: "<%=Constances.SYSTEM_CONTEXT_PATH%>/SmartEditor/SmartEditor2Skin.html",
		htParams: { fOnBeforeUnload : function(){}}
	});
	var btnUpload=$('#btnAttach');
	var status=$('#status');
	new AjaxUpload(btnUpload, {
		action:'<%=Constances.SYSTEM_CONTEXT_PATH%>/common/imageResizeProcess.sys',
		name:'imageFile',
		data:{},
		onSubmit:function(file,ext) {
		    if(!(ext && /^(jpg|jpeg|gif)$/.test(ext))) {
	             alert('이미지 파일(jpg,jpeg,gif) 파일만 등록 가능합니다.');
	            //status.text("이미지 파일만 등록 가능합니다.");   // extension is not allowed
	            return false;
	         }
			if(!confirm("이미지를 등록하시겠습니까?")) {
				return false;
			}
			status.text('Uploading...');
		},
		onComplete: function(file,response) {
			status.text('');
			var result = eval("(" +response + ")");
			
			var imgPathForORGIN = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.ORGIN;
			var imgPathForSMALL = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.SMALL;
			var imgPathForMEDIUM = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.MEDIUM;
			var imgPathForLARGE = "<%=Constances.SYSTEM_IMAGE_PATH%>/" + result.LARGE;
			
			// 이미지 변경
			$('#SMALL').attr('src',imgPathForSMALL);
			$('#MEDIUM').attr('src',imgPathForMEDIUM);
			$('#LARGE').attr('src',imgPathForLARGE);
			
			// 경로 설정
			$('#originalImgPathAuc').val(result.ORGIN);
			$('#largeImgPathAuc').val(result.LARGE);
			$('#middleImgPathAuc').val(result.MEDIUM);
			$('#smallImgPathAuc').val(result.SMALL);
		}
	});
});
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
	$(document).on("blur", "input:text[requiredNumber]", function() {
	    $(this).number(true);
	});
	
 	<%if(bidstate.equals("10") && loginUserDto.getSvcTypeCd().equals("ADM")){%>
	$("#prodTitle").hide();
	$("#venProdDetail").hide();
	<%}%>
	// Object Event
	$("#btnAttachDel").click( function() { attachDel(); });
	$("#btnTenNewProduct").click( function() {
		fnAuth();
		//tenNewProduct(); 
	});
	$('#faiButton').click( function() { updateState('90','<%=loginUserDto.getUserId()%>'); }); //유찰
	$('#sucButton').click( function() { updateState('50','<%=loginUserDto.getUserId()%>'); }); //낙찰
// 	$('#regButton').click( function() { registProduct(); }); //상품등록
	$('#btnCommonClose').click(function() { fnThisPageClose(); });
	
	// 상품입찰공고 상태값 조회
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductBidDetailDataInit.sys',
		{bidid:'<%=bidid%>'},
		function(arg) {
			var detailInfo = eval('(' + arg + ')').detailInfo;
			$('#bidid').val(detailInfo.bidid);
			$('#bidname').val(detailInfo.bidname);
			$('#bidstate').val(detailInfo.bidstate);
			$('#stand_good_name').val(detailInfo.stand_good_name);
			$('#insert_date').val((detailInfo.insert_date).substring(0,10));
			$('#insert_date_time').val((detailInfo.insert_date).substring(11,13));
			$('#insert_date_min').val((detailInfo.insert_date).substring(14,16));
			$('#stand_good_spec_desc').val(detailInfo.stand_good_spec_desc);
			$('#bidenddateday').val((detailInfo.bidenddate).substring(0,10));
			$('#bidenddatetime').val((detailInfo.bidenddate).substring(11,13));
			$('#bidenddatemin').val((detailInfo.bidenddate).substring(14,16));
			$('#is_use_certificate').val(detailInfo.is_use_certificate);
			$('#hope_sale_price').val(Number(detailInfo.hope_sale_price));
			$('#bidnote').val(detailInfo.bidnote);
			$('#bidNoteField').val(detailInfo.bidnote);
			$('#firstattachseqBid').val(detailInfo.FIRSTATTACHSEQ);
			$('#attach_file_path1Bid').val(detailInfo.firstAttachPath);
			$('#attach_file_name1Bid').html(detailInfo.firstAttachName);
			$('#secondattachseqBid').val(detailInfo.SECONDATTACHSEQ);
			$('#attach_file_path2Bid').val(detailInfo.secondAttachPath);
			$('#attach_file_name2Bid').html(detailInfo.secondAttachName);
			$('#thirdattachseqBid').val(detailInfo.THIRDATTACHSEQ);
			$('#attach_file_path3Bid').val(detailInfo.thirdAttachPath);
			$('#attach_file_name3Bid').html(detailInfo.thirdAttachName);
			$('#newgoodid').val(detailInfo.newgoodid);
			$('#bidEndDate').val(detailInfo.bidenddate);
			$('#bidInsertDate').val(detailInfo.insert_date);
			//구분 코드리스트
			if(detailInfo.bid_classify != ''){
				$.post(
					"/common/etc/selectCodeList/list.sys",
					{
						codeTypeCd:"bid_classify",
						isUse:"1"
					},
					function(arg){
						var list = eval('('+arg+')').list;
						for(var i=0; i<list.length; i++){
							$("#bidClassify").append("<option value='"+list[i].codeVal1+"'>"+list[i].codeNm1+"</option>");
						}
						$("#bidClassify").val(detailInfo.bid_classify);
					}
				);
			}
			
			fnInitComponentForUpd();
		}
	);
	
	
	function fnInitComponentForUpd() {
		$('#bidstate').attr("disabled",true);
		$('#bidenddateday').attr("disabled",true);
		$('#bidenddatetime').attr("disabled",true);
		$('#bidenddatemin').attr("disabled",true);
		$('#is_use_certificate').attr("disabled",true);
		$('#bidstate').attr("class","select_none");
		$('#bidenddateday').attr("class","input_text_none");
		$('#bidenddatetime').attr("class","select_none");
		$('#bidenddatemin').attr("class","select_none");
		$('#is_use_certificate').attr("class","select_none");
		
		$('#insert_date_time').attr("disabled",true);
		$('#insert_date_time').attr("class","select_none");
		$('#insert_date_min').attr("disabled",true);
		$('#insert_date_min').attr("class","select_none");
		$('#bidClassify').attr("disabled",true);
		$('#bidClassify').attr("class","select_none");
		//상품입찰공급사정보 화면 초기화
		fnInitComponentBidAuction();
	}
	
	//상품입찰공급사정보 화면 component 상태 초기화
	function fnInitComponentBidAuction() {
		if('<%=loginUserDto.getSvcTypeCd()%>' == 'VEN') {
			// 공급사인 경우
			$('#faiButton').hide();
			$('#sucButton').hide();
// 			$('#regButton').hide();
			if($('#bidstate').val() == '10') {
				if('<%=vendorbidstate%>' == '10') { //미투찰(상품입찰공급사정보)
					// 등록인 경우
// 					$('#btnAttach').show();
// 					$('#btnAttachDel').show();
					$('#btnAttach').hide();
					$('#btnAttachDel').hide();
					$('#btnAttach1').show();
					$('#btnAttach2').show();
					$('#btnAttach3').show();
					$('#btnAttachDel1').hide();
					$('#btnAttachDel2').hide();
					$('#btnAttachDel3').hide();
					$('#btnTenNewProduct').show();
					
					fnInitDetailDataBidAuction();
				} else if('<%=vendorbidstate%>' == '15') { //투찰(상품입찰공급사정보)
					// 수정인 경우
// 					$('#btnAttach').show();
// 					$('#btnAttachDel').show();
					$('#btnAttach').hide();
					$('#btnAttachDel').hide();
					$('#btnAttach1').show();
					$('#btnAttach2').show();
					$('#btnAttach3').show();
					$('#btnAttachDel1').show();
					$('#btnAttachDel2').show();
					$('#btnAttachDel3').show();
					$('#btnTenNewProduct').show();
					
					fnGetDetailDataBidAuction('<%=bidid%>','<%=vendoridAuc%>');
				} else if('<%=vendorbidstate%>' == '50') { //낙찰(상품입찰공급사정보)
					$('#btnAttach').hide();
					$('#btnAttachDel').hide();
					$('#btnAttach1').hide();
					$('#btnAttach2').hide();
					$('#btnAttach3').hide();
					$('#btnAttachDel1').hide();
					$('#btnAttachDel2').hide();
					$('#btnAttachDel3').hide();
					$('#btnTenNewProduct').hide();
					
					fnGetDetailDataBidAuction('<%=bidid%>','<%=vendoridAuc%>');
				}
			} else {
				$('#btnAttach').hide();
				$('#btnAttachDel').hide();
				$('#btnAttach1').hide();
				$('#btnAttach2').hide();
				$('#btnAttach3').hide();
				$('#btnAttachDel1').hide();
				$('#btnAttachDel2').hide();
				$('#btnAttachDel3').hide();
				$('#btnTenNewProduct').hide();
				
				fnGetDetailDataBidAuction('<%=bidid%>','<%=vendoridAuc%>');
			}
		} else {
			// 운영사인 경우
			$('#btnAttach').hide();
			$('#btnAttachDel').hide();
			$('#btnAttach1').hide();
			$('#btnAttach2').hide();
			$('#btnAttach3').hide();
			$('#btnAttachDel1').hide();
			$('#btnAttachDel2').hide();
			$('#btnAttachDel3').hide();
			$('#btnTenNewProduct').hide();
			if($('#bidstate').val() == "10") {//입찰생성
				$('#faiButton').hide();
				$('#sucButton').hide();
// 				$('#regButton').hide();
			} else if($('#bidstate').val() == "20") {//입찰마감
				$('#faiButton').show();
				$('#sucButton').show();
// 				$('#regButton').hide();
			} else if($('#bidstate').val() == "50") {//낙찰
				$('#faiButton').hide();
				$('#sucButton').show();
// 				$('#regButton').show();
			} else if($('#bidstate').val() == "90") {//유찰
				$('#faiButton').hide();
				$('#sucButton').hide();
// 				$('#regButton').hide();
			}
			$('#good_nameAuc').attr("disabled",true);
			$('#sale_unit_priceAuc').attr("disabled",true);
			
			$('#good_spec_descAuc1').attr("disabled",true);

			$('#deli_mini_dayAuc').attr("disabled",true);
			$('#make_comp_nameAuc').attr("disabled",true);
			$('#orde_clas_codeAuc').attr("disabled",true);
			$('#deli_mini_quanAuc').attr("disabled",true);
			$('#originalImgPathAuc').attr("disabled",true);
			$('#good_same_wordAuc1').attr("disabled",true);
			$('#good_same_wordAuc2').attr("disabled",true);
			$('#good_same_wordAuc3').attr("disabled",true);
			$('#good_same_wordAuc4').attr("disabled",true);
			$('#good_same_wordAuc5').attr("disabled",true);
			$('#good_nameAuc').attr("class","input_text_none");
			$('#sale_unit_priceAuc').attr("class","input_text_none");
			$('#good_spec_descAuc1').attr("class","input_text_none");
			$('#deli_mini_dayAuc').attr("class","input_text_none");
			$('#make_comp_nameAuc').attr("class","input_text_none");
			$('#orde_clas_codeAuc').attr("class","select_none");
			$('#deli_mini_quanAuc').attr("class","input_text_none");
			$('#originalImgPathAuc').attr("class","input_text_none");
			$('#good_same_wordAuc1').attr("class","input_text_none");
			$('#good_same_wordAuc2').attr("class","input_text_none");
			$('#good_same_wordAuc3').attr("class","input_text_none");
			$('#good_same_wordAuc4').attr("class","input_text_none");
			$('#good_same_wordAuc5').attr("class","input_text_none");
		}
	}
	
	function fnInitDetailDataBidAuction() {
		// 상품입찰공급사정보 초기화
		$('#vendornmAuc').val('<%=vendornmAuc%>'); //공급업체명
		$('#vendoridAuc').val('<%=vendoridAuc%>'); //공급업체Id
		$('#bidding_user_idAuc').val('<%=bidding_user_idAuc%>'); //투찰자Id
		$('#bidding_dateAuc').val('<%=bidding_dateAuc%>'); //상품투찰일자
		$('#make_comp_nameAuc').val('<%=vendornmAuc%>');
		
		//공급사 투찰 등록수정
		var standGoodName = $("#stand_good_name").val();
		$("#good_nameAuc").val(standGoodName);//상품명
		var standGoodSpecDesc = $("#stand_good_spec_desc").val();
		$("#good_spec_descAuc1").val(standGoodSpecDesc);//상품규격
		$("#deli_mini_quanAuc").val(0);//최소주문수량
		$("#deli_mini_dayAuc").val(0);//납품소요일

		
		$("#good_nameAuc").attr("disabled", "true");//상품명
		$("#deli_mini_quanAuc").attr("disabled", "true");//최소주문수량
		$("#deli_mini_dayAuc").attr("disabled", "true");//납품소요일
		
		//상품 규격 
		$("#good_spec_descAuc1").attr("disabled", "true");
		//동의어
		$("#good_same_wordAuc1").attr("disabled", "true");
		$("#good_same_wordAuc2").attr("disabled", "true");
		$("#good_same_wordAuc3").attr("disabled", "true");
		$("#good_same_wordAuc4").attr("disabled", "true");
		$("#good_same_wordAuc5").attr("disabled", "true");
		
		//상품 이미지
		$("#originalImgPathAuc").attr("disabled", "true");
		
	}

});
// $(window).bind('resize', function() { 
<%-- 	$("#list").setGridHeight('<%=listHeight%>'); --%>
<%-- 	$("#list").setGridWidth('<%=listWidth%>'); --%>
// }).trigger('resize');
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
jq(function() {
	jq("#list").jqGrid({
		url:'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductBidAuctionListJQGrid.sys',
		datatype:'json',
		mtype:'POST',
		colNames:['투찰시간','공급업체명','입찰 상태',<%if(!bidstate.equals("10")){%> '투찰가격',<%}%>'공급업체코드','대표자','연락처','이미지여부','설명여부','상품등록여부','상품코드','공급사ID','입찰ID'],
		colModel:[
			{ name:'bidding_date',index:'bidding_date',width:120,align:'center',search:false,sortable:true,editable:false },//투찰시간
			{ name:'VENDORNM',index:'VENDORNM',width:200,align:'left',search:false,sortable:true,editable:false },//공급업체명
			{ name:'vendorbidstate',index:'vendorbidstate',width:60,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"10:미투찰;15:투찰;50:낙찰"}
			},//입찰 상태
			<%if(!bidstate.equals("10")){%>
			{ name:'sale_unit_price',index:'sale_unit_price',width:100,align:'right',search:false,sortable:true
				,editable:false,sorttype:'integer',formatter:'integer',formatoptions:{ decimalSeparator:"", thousandsSeparator:",", decimalPlaces: 0, prefix:"" }
			},//투찰가격
			<%}%>
			{ name:'VENDORCD',index:'VENDORCD',width:80,align:'center',search:false,sortable:true,editable:false,hidden:true },//공급업체코드
			{ name:'PRESSENTNM',index:'PRESSENTNM',width:60,align:'center',search:false,sortable:true,editable:false,hidden:true },//대표자
			{ name:'PHONENUM',index:'PHONENUM',width:60,align:'center',search:false,sortable:false,editable:false,hidden:true },//연락처
			{ name:'isSetImage',index:'isSetImage',width:60,align:"center",search:false,sortable:false,editable:false },//이미지여부
			{ name:'isSetDesc',index:'isSetDesc',width:50,align:"center",search:false,sortable:false,editable:false },//설명여부
			{ name:'IS_REG_GODD',index:'IS_REG_GODD',width:80,align:"center",search:false,sortable:false
				,editable:false,formatter:"select",editoptions:{value:"1:등록;0:미등록"}
			},//상품등록여부
			
			{ name:'good_iden_numb',index:'good_iden_numb',width:60,align:'left',search:false,sortable:true,editable:false,hidden:true },//상품코드
			
			{ name:'vendorid',index:'vendorid',align:'center',search:false,sortable:false,hidden:true },//공급사ID
			{ name:'bidid',index:'bidid',align:'center',search:false,sortable:false,hidden:true }//입찰ID
		],
		postData: {
			bidid:'<%=bidid%>'
		},
		rowNum:30,rownumbers:false,rowList:[30,50,100],pager:'#pager',
		height:'<%=listHeight%>',width:$(window).width()-60 + Number(gridWidthResizePlus),
		sortname:'bidding_date',sortorder:'asc',
		viewrecords:true,emptyrecords:'Empty records',loadonce: false,shrinkToFit:false,	//해당라인은 그리드 공통으로 들어가면 될거 같음(그냥 갖다 붙이 삼..)
		loadComplete:function() {
			var top_rowid = $("#list").getDataIDs()[0];
			$("#list").setSelection(top_rowid);
		},
		onSelectRow:function(rowid,iRow,iCol,e) {
			var row = jq("#list").jqGrid('getGridParam','selrow');
			var selrowContent = jq("#list").jqGrid('getRowData',row);
			var bidid = selrowContent.bidid;
			var vendorid = selrowContent.vendorid;
			if(row != null) {
				//alert("1111111");
				fnGetDetailDataBidAuction(bidid,vendorid);
			}
		},
		afterInsertRow: function(rowid, aData){
			var selrowContent = jq("#list").jqGrid('getRowData',rowid);
			//전화번호 형식으로 변경
			jq("#list").jqGrid('setRowData', rowid, {PHONENUM: fnSetTelformat(selrowContent.PHONENUM)});
		},
		ondblClickRow:function(rowid,iRow,iCol,e) {},
		onCellSelect:function(rowid,iCol,cellcontent,target) {},
		loadError:function(xhr,st,str) { $('#list').html(xhr.responseText); },
		jsonReader: { root:'list',page:'page',total:'total',records:'records',repeatitems:false,cell:'cell' }
	});
});
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
function attachDel() {
	// 이미지 변경
	$('#SMALL').attr('src','/img/system/imageResize/prod_img_50.gif');
	$('#MEDIUM').attr('src','/img/system/imageResize/prod_img_70.gif');
	$('#LARGE').attr('src','/img/system/imageResize/prod_img_100.gif');
	
	// 경로 설정
	$('#originalImgPathAuc').val('');
	$('#largeImgPathAuc').val('');
	$('#middleImgPathAuc').val('');
	$('#smallImgPathAuc').val('');
	$('#originalImgPathAuc').focus();
}

function fnGetDetailDataBidAuction(bidid,vendorid) {
	// 상품입찰공급사정보 상태값 조회
	$.post(
		'<%=Constances.SYSTEM_CONTEXT_PATH%>/product/newProductBidAuctionDetailDataInit.sys',
		{bidid:bidid,vendorid:vendorid},
		function(arg) {
			var detailInfo = eval('(' + arg + ')').detailInfo;
			$('#vendornmAuc').val(detailInfo.VENDORNM);
			$('#vendoridAuc').val(detailInfo.vendorid);
			$('#bidding_user_idAuc').val(detailInfo.bidding_user_id);
			$('#bidding_dateAuc').val(detailInfo.bidding_date);
			$('#good_nameAuc').val(detailInfo.good_name);
			if('<%=loginUserDto.getSvcTypeCd()%>' == 'ADM' && $('#bidstate').val() == '10' && detailInfo.sale_unit_price != '') {
				$('#sale_unit_priceAuc').val('***************');
			} else {
				$('#sale_unit_priceAuc').val(Number(detailInfo.sale_unit_price));
            }
			$('#good_spec_descAuc1').val(detailInfo.good_spec_desc);
			$('#deli_mini_dayAuc').val(detailInfo.deli_mini_day);
			$('#make_comp_nameAuc').val(detailInfo.make_comp_name);
			$('#orde_clas_codeAuc').val(detailInfo.orde_clas_code);
			$('#deli_mini_quanAuc').val(detailInfo.deli_mini_quan);
			$('#originalImgPathAuc').val(detailInfo.original_img_path);
			if(detailInfo.original_img_path == "") {
				$('#largeImgPathAuc').val("");
				$('#middleImgPathAuc').val("");
				$('#smallImgPathAuc').val("");
			}
			if(detailInfo.small_img_path == "") {
				$('#SMALL').attr('src',"/img/system/imageResize/prod_img_50.gif");
			} else {
				$('#SMALL').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.small_img_path);
				$('#smallImgPathAuc').val(detailInfo.small_img_path);
			}
			if(detailInfo.middle_img_path == "") {
				$('#MEDIUM').attr('src',"/img/system/imageResize/prod_img_70.gif");
			} else {
				$('#MEDIUM').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.middle_img_path);
				$('#middleImgPathAuc').val(detailInfo.middle_img_path);
			}
			if(detailInfo.large_img_path == "") {
				$('#LARGE').attr('src',"/img/system/imageResize/prod_img_100.gif");
			} else {
				$('#LARGE').attr('src',"<%=Constances.SYSTEM_IMAGE_PATH%>/"+detailInfo.large_img_path);
				$('#largeImgPathAuc').val(detailInfo.large_img_path);
			}
			$('#tx_load_content').val(unescape(detailInfo.good_desc)+" ");
			
			if (oEditors.length > 0) {
			 oEditors.getById["tx_load_content"].exec("LOAD_CONTENTS_FIELD");
			}
			
			$('#good_same_wordAuc1').val(detailInfo.good_same_word.split("‡")[0]);
			$('#good_same_wordAuc2').val(detailInfo.good_same_word.split("‡")[1]);
			$('#good_same_wordAuc3').val(detailInfo.good_same_word.split("‡")[2]);
			$('#good_same_wordAuc4').val(detailInfo.good_same_word.split("‡")[3]);
			$('#good_same_wordAuc5').val(detailInfo.good_same_word.split("‡")[4]);
			$('#firstattachseq').val(detailInfo.FIRSTATTACHSEQ);
			$('#attach_file_path1').val(detailInfo.firstAttachPath);
			$('#attach_file_name1').html(detailInfo.firstAttachName);
			$('#secondattachseq').val(detailInfo.SECONDATTACHSEQ);
			$('#attach_file_path2').val(detailInfo.secondAttachPath);
			$('#attach_file_name2').html(detailInfo.secondAttachName);
			$('#thirdattachseq').val(detailInfo.THIRDATTACHSEQ);
			$('#attach_file_path3').val(detailInfo.thirdAttachPath);
			$('#attach_file_name3').html(detailInfo.thirdAttachName);
			
			//인풋태그 disabled 만들기
			$("#good_nameAuc").attr("disabled", "true");//상품명
			$("#deli_mini_quanAuc").attr("disabled", "true");//최소주문수량
			$("#deli_mini_dayAuc").attr("disabled", "true");//납품소요일
			
			//상품 규격 
			$("#good_spec_descAuc1").attr("disabled", "true");
			
			//동의어
			$("#good_same_wordAuc1").attr("disabled", "true");
			$("#good_same_wordAuc2").attr("disabled", "true");
			$("#good_same_wordAuc3").attr("disabled", "true");
			$("#good_same_wordAuc4").attr("disabled", "true");
			$("#good_same_wordAuc5").attr("disabled", "true");
			
			//상품 이미지
			$("#originalImgPathAuc").attr("disabled", "true");
		}
	);
}

function fnReplaceAll(str1, str2, str3){ 
    var oridata = str1; 
    
    while(oridata.indexOf(str2) > -1){ 
		oridata = oridata.replace(str2,str3); 
    }
    
    return oridata; 
}

function tenNewProduct(Proc) {
	// 입찰종료일자 점검
	var today = new Date();
	var dateString = $('#bidenddateday').val()+"-"+$('#bidenddatetime').val()+"-"+$('#bidenddatemin').val();
	var dateArray = dateString.split("-");
	var dateObj = new Date(dateArray[0], Number(dateArray[1])-1, dateArray[2], dateArray[3], dateArray[4]);
	var betweenDay = (dateObj.getTime() - today.getTime())/1000/60/60/24;
// 	if(betweenDay < 0) {
// 		alert("입찰종료일자가 지났습니다.\n투찰을 할 수 없습니다.");
// 		return;
// 	}
	var bidid = $('#bidid').val();
	var vendorid = $('#vendoridAuc').val();//공급사Id
	var bidding_user_idAuc = $('#bidding_user_idAuc').val();//투찰자Id
	var good_nameAuc = $('#good_nameAuc');//상품명
	var sale_unit_priceAuc = $('#sale_unit_priceAuc');//매입액
	var deli_mini_dayAuc = $('#deli_mini_dayAuc');//납품소요일
	 
	var good_spec_descAuc = $('#good_spec_descAuc1').val();
	var make_comp_nameAuc = $('#make_comp_nameAuc').val();//제조사
	var orde_clas_codeAuc = $('#orde_clas_codeAuc option:selected').val();//단위
	var deli_mini_quanAuc = $('#deli_mini_quanAuc');//최소주문수량
	var originalImgPathAuc = $('#originalImgPathAuc');//대표이지미원본
	var largeImgPathAuc = $('#largeImgPathAuc').val();//대표이미지대
	var middleImgPathAuc = $('#middleImgPathAuc').val();//대표이미지중
	var smallImgPathAuc = $('#smallImgPathAuc').val();//대표이미지소
	
	if (oEditors.length > 0) { 
	 oEditors.getById["tx_load_content"].exec("UPDATE_CONTENTS_FIELD", []);
	}
	
	var message = $('#tx_load_content').val();//상품상세설명, 에디터 변경으로 인해서 주석처리 한 부분 때문에, 투찰이 진행이 안됨 확인 필요. 비트큐브 임상건 2015-12-03
	var good_same_wordAuc = $('#good_same_wordAuc1').val()+"‡"+$('#good_same_wordAuc2').val()+"‡"+$('#good_same_wordAuc3').val()
							 +"‡"+$('#good_same_wordAuc4').val()+"‡"+$('#good_same_wordAuc5').val();//상품동의어
	var firstattachseq = $('#firstattachseq').val();//첨부파일1 
	var secondattachseq = $('#secondattachseq').val();//첨부파일2
	var thirdattachseq = $('#thirdattachseq').val();//첨부파일3
	var bidEndDate = $("#bidEndDate").val();
	var bidInsertDate = $("#bidInsertDate").val();
	
	message = fnReplaceAll(message, unescape("%uFEFF"), "");
	
	$.post(
		"/product/bidEndDateCompare.sys",
		{
			bidEndDate:bidEndDate,
			bidInsertDate:bidInsertDate
		},
		function (arg) {
			var result = eval('('+arg+')').customResponse;
			if(result.success == false){
				alert(result.message);
			}else{
				if(good_nameAuc.val() == "") {
					alert("상품명을 입력해 주십시오.");
					good_nameAuc.focus();
					return;
				}
				if(sale_unit_priceAuc.val() == "" ){
					alert("투찰금액을 입력해 주십시오.");
					$('#sale_unit_priceAuc').focus(); 
					return;
				} else {
					//alert("투찰하신 투찰금액은 "+sale_unit_priceAuc.val()+"원 입니다.");
					$('#saleUnitPriceAucField').text( fnComma( sale_unit_priceAuc.val() )+"원");
					fnNewProductTenderMajorPop();
					if(Proc == "proc"){
						
					}
					else{
						return;
					}
				}
				
				if( parseInt(sale_unit_priceAuc.val().replace(/,/g , "")) == 0 ) {
					alert("매입액을 0보다 큰값을 입력하셔야 합니다.");
					$('#sale_unit_priceAuc').focus(); 
					return;
				}
				
				if(deli_mini_dayAuc.val() == "") {
					alert("납품소요일을 입력해 주십시오.");
					$('#deli_mini_dayAuc').focus();
					return;
				}
				
				if(orde_clas_codeAuc == ""){
					alert("주문단위를 선택해 주십시오.");
					$('#orde_clas_codeAuc').focus();
					return;
				}
				
				if(deli_mini_quanAuc.val() == "") {
					alert("최소주문수량을 입력해 주십시오.");
					$('#deli_mini_quanAuc').focus();
					return;
				}
				
				var params = {
						bidid:bidid,
						vendorid:vendorid,
						good_name:good_nameAuc.val(),
						good_spec_desc:good_spec_descAuc,
						orde_clas_code:orde_clas_codeAuc,
						sale_unit_price:sale_unit_priceAuc.val(),
						deli_mini_day:deli_mini_dayAuc.val(),
						deli_mini_quan:deli_mini_quanAuc.val(),
						make_comp_name:make_comp_nameAuc,
						original_img_path:originalImgPathAuc.val(),
						large_img_path:largeImgPathAuc,
						middle_img_path:middleImgPathAuc,
						small_img_path:smallImgPathAuc,
						good_desc:message,
						good_same_word:good_same_wordAuc,
						FIRSTATTACHSEQ:firstattachseq,
						SECONDATTACHSEQ:secondattachseq,
						THIRDATTACHSEQ:thirdattachseq,
						bidding_user_id:bidding_user_idAuc };
				
				//if(!confirm("입력한 투찰상품정보를 등록하겠습니까?")) return;
				$.post(
					"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/bidAuctionTrans.sys",
					params,
					function(arg){ 
						if(fnTransResult(arg, false)) {//성공시
							alert('정상적으로 투찰이\n완료 되었습니다.');
							fnSuccessBidAuctionProcess();
						}
					}
				);
			}
		}
	);
}

function fnSuccessBidAuctionProcess() {
	if('<%=popupClose%>' == "true") {
		window.close();
	}
	window.opener.fnSuccessBidAuctionProcess();
	
// 	var tempName = dialogArguments;
// 	tempName.fnSuccessBidAuctionProcess();
}

function updateState(state, insert_user_id) {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	var selrowContent = jq("#list").jqGrid('getRowData',row);
	var bidid = selrowContent.bidid;
	var vendorid = selrowContent.vendorid;
	var newgoodid = $('#newgoodid').val();
	var vendorbidstate = selrowContent.vendorbidstate;//789
	var IS_REG_GODD = selrowContent.IS_REG_GODD;
	var msg = "";
	if(state == '90') { //유찰
		msg = "입찰을 유찰 하시겠습니까?";
	} else if(state == '50') { //낙찰
		if(vendorbidstate == "10") {
			alert("공급업체가 투찰하지 않았습니다.\n\r낙찰이 불가능합니다.");
			return;
		} else if(vendorbidstate == "15") {
			msg = "선택한 공급사를 낙찰 하시겠습니까?";
		} else if(vendorbidstate == "50") {
			alert("이미 낙찰된 공급사입니다.");
			return;
		}
	}
	
	var params = {
		bidid:bidid,
		vendorid:vendorid,
		newgoodid:newgoodid,
		bidstate:state,
		vendorbidstate:state,
		insert_user_id:insert_user_id };
	
	if(!confirm(msg)) return;
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/product/bidAuctionStateTrans.sys",
		params,
		function(arg){
			if(fnTransResult(arg, false)) {//성공시
				var msg = eval('(' + arg + ')').msg;
				alert(msg);
				fnSuccessBidAuctionProcess();
				
				if(params['bidstate'] == '90') {
					window.close();
				} else if(params['bidstate'] == '50'){
					jq("#list").trigger("reloadGrid");
					$('#faiButton').hide();
// 					$('#regButton').show();
				}
			}
		}
	);
}

// 상품등록
function registProduct() {
	var row = jq("#list").jqGrid('getGridParam','selrow');
	var selrowContent = jq("#list").jqGrid('getRowData',row);
	var bidid = selrowContent.bidid;
	var vendorid = selrowContent.vendorid;
	var vendorbidstate = selrowContent.vendorbidstate;
	var IS_REG_GODD = selrowContent.IS_REG_GODD;
	var good_iden_numb = selrowContent.good_iden_numb;
	
	if(vendorbidstate == "10") {
		alert("공급업체가 투찰하지 않았습니다.\n\r상품등록이 불가능합니다.");
		return;
	} else if(vendorbidstate == "15") {
		alert("공급업체가 낙찰되지 않았습니다.\n\r상품등록이 불가능합니다.");
		return;
	} else if(vendorbidstate == "50") {
		if(IS_REG_GODD == "1") {
			alert("상품이 이미 등록되었습니다.");
			return;
		}
		if(!confirm("상품을 등록하시겠습니까?")) return;
		//fnProductDetailView('<%=menuId %>',good_iden_numb, vendorid, bidid, vendorid);
		window.close();
// 		var tempName = dialogArguments;
<%-- 		tempName.fnSuccessProductDetailView('<%=menuId %>',good_iden_numb, vendorid, bidid, vendorid); --%>
		window.opener.fnSuccessProductDetailView('<%=menuId %>',good_iden_numb, vendorid, bidid, vendorid);
	}
}

//상품등록후 그리드 다시 그리기
function fnReLoadDataGrid() {
	jq("#list").trigger("reloadGrid");
}

/**
 * 해당 Page 닫기
 */
function fnThisPageClose() {
	this.close();
// 	if(typeof(window.dialogArguments) == 'object') {
// 		top.close();
// 	}
};
</script>

<%
/**------------------------------------첨부파일 사용방법 시작---------------------------------
* fnUploadDialog(attach_title, attach_seq, callbackString) 을 호출하여 Div팝업을 Display ===
* attach_title:첨부파일타이틀 
* attach_seq:기존첨부파일 일련번호(없을땐 공백)
* callbackString:콜백함수(문자열), 콜백함수파라메타는 3개(첨부seq, 파일명, 파일경로) 
* -> 만약 fnUploadDialog("사업자등록증", "", "fnAttach1"); 로 호출하였다면
*    fnAttach1 함수는 부모페이지에 있어야 하고 파라메터는 첨부seq, 파일명, 파일경로 로 넘겨줌
*/
%>
<%@ include file="/WEB-INF/jsp/common/attachFileDiv.jsp" %>
<!-- 첨부파일관련 스크립트 -->
<script type="text/javascript">
	$(document).ready(function() {
		$("#btnAttach1").click(function(){ fnUploadDialog("첨부파일1", $("#firstattachseq").val(), "fnCallBackAttach1"); });
		$("#btnAttach2").click(function(){ fnUploadDialog("첨부파일2", $("#secondattachseq").val(), "fnCallBackAttach2"); });
		$("#btnAttach3").click(function(){ fnUploadDialog("첨부파일3", $("#thirdattachseq").val(), "fnCallBackAttach3"); });
	});
	
	/**
	 * 첨부파일1 파일관리
	 */
	function fnCallBackAttach1(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#firstattachseq").val(rtn_attach_seq);
		$("#attach_file_name1").text(rtn_attach_file_name);
		$("#attach_file_path1").val(rtn_attach_file_path);
		$('#btnAttachDel1').show();
	}
	
	/**
	 * 첨부파일2 파일관리
	 */
	function fnCallBackAttach2(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#secondattachseq").val(rtn_attach_seq);
		$("#attach_file_name2").text(rtn_attach_file_name);
		$("#attach_file_path2").val(rtn_attach_file_path);
		$('#btnAttachDel2').show();
	}
	
	/**
	 * 첨부파일3 파일관리
	 */
	function fnCallBackAttach3(rtn_attach_seq, rtn_attach_file_name, rtn_attach_file_path) {
		$("#thirdattachseq").val(rtn_attach_seq);
		$("#attach_file_name3").text(rtn_attach_file_name);
		$("#attach_file_path3").val(rtn_attach_file_path);
		$('#btnAttachDel3').show();
	}
	
	/**
	 * 파일다운로드
	 */
	function fnAttachFileDownload(attach_file_path) {
		var url = "<%=Constances.SYSTEM_CONTEXT_PATH%>/common/attachFileDownload.sys";
		var data = "attachFilePath="+attach_file_path;
		$.download(url,data,'post');
	}
	jQuery.download = function(url, data, method) {
		// url과 data를 입력받음
		if( url && data ) {
			// data 는 string 또는 array/object 를 파라미터로 받는다.
			data = typeof data == 'string' ? data : jQuery.param(data);
			// 파라미터를 form의 input으로 만든다.
			var inputs = '';
			jQuery.each(data.split('&'), function() {
				var pair = new Array();
				pair = this.split('=');
				inputs+='<input type="hidden" name="'+ pair[0] +'" value="'+ pair[1] +'" />';
			});
			// request를 보낸다.
			jQuery('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
			.appendTo('body').submit().remove();
		};
	};
	
	/**
	 * 파일삭제
	 */
	function fnAttachDel(columnName) {
		if(columnName=='firstattachseq') {
			if($("#firstattachseq").val() == '') { return; }
		} else if(columnName=='secondattachseq') {
			if($("#secondattachseq").val() == '') { return; }
		} else if(columnName=='thirdattachseq') {
			if($("#thirdattachseq").val() == '') { return; }
		}
		
		if(!confirm("첨부파일을 삭제하시겠습니까?")) return;
		if(columnName=='firstattachseq') {
			$("#firstattachseq").val('');
			$("#attach_file_name1").text('');
			$("#attach_file_path1").val('');
			$("#btnAttachDel1").hide();
		} else if(columnName=='secondattachseq') {
			$("#secondattachseq").val('');
			$("#attach_file_name2").text('');
			$("#attach_file_path2").val('');
			$("#btnAttachDel2").hide();
		} else if(columnName=='thirdattachseq') {
			$("#thirdattachseq").val('');
			$("#attach_file_name3").text('');
			$("#attach_file_path3").val('');
			$("#btnAttachDel3").hide();
		}
	}
</script>
<%//------------------------------------첨부파일 사용방법 끝--------------------------------- %>

<script type="text/javascript">
//입찰종료시간과 현재시스템날짜를 비교
var bidEndDateCompare = function (){
	var bidEndDate = $("#bidEndDate").val();
	$.post(
		"/product/bidEndDateCompare.sys",
		{
			bidEndDate:bidEndDate
		},
		function (arg) {
			var result = eval('('+arg+')').customResponse;
			if(result.success == false){
				alert("입찰종료일자가 지났습니다.\n투찰을 할 수 없습니다.");
				return false;
			}
		}
	);
	return true;
}
</script>

</head>

<body>
<div style="position:absolute;top:0;left:0">
<form id="frm" name="frm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> 
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr valign="top">
				<td width="20" valign="middle">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width:14px;height:15px;" /></td>
				<td height="29" class="ptitle"><%=strTitle%></td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top">
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">대표상품정보</td>
				<td align="right" class="ptitle">
					<img id="faiButton" src="/img/system/btn_type3_noDeal.gif" width="65" height="22" style="cursor: pointer;" /></td>
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
				<td class="table_td_subject" width="60">입찰명</td>
				<td class="table_td_contents">
					<input id="bidname" name="bidname" type="text" value="" size="" maxlength="30" style="width:90%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject" width="60">입찰상태</td>
				<td class="table_td_contents">
					<select id="bidstate" name="bidstate" class="select" style="width:90%;">
<%
	@SuppressWarnings("unchecked")
	List<CodesDto> bidStateCd = (List<CodesDto>)request.getAttribute("bidStateCd");

	if(bidStateCd != null && bidStateCd.size() > 0){
		for(CodesDto dto : bidStateCd){
%>
						<option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%		
		}
	}
%>
					</select>
				</td>
				<td class="table_td_subject" width="60">입찰번호</td>
				<td class="table_td_contents">
					<input id="bidid" name="bidid" type="text" value="" size="" maxlength="30" style="width:90%;" class="input_text_none" disabled="disabled" />
					<input id="newgoodid" name="newgoodid" type="hidden" value=""/></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표상품명</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_name" name="stand_good_name" type="text" value="" size="" maxlength="100" style="width:95%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">입찰시작일자</td>
				<td class="table_td_contents">
					<input id="insert_date" name="insert_date" type="text" style="width:73px;" class="input_text_none" disabled="disabled" />
					<select id="insert_date_time" name="insert_date_time" class="select">
<%	for(int i = 0 ; i < 24 ; i++){
		String strTime = "";
		if(i < 10)	strTime = "0" + i;
		else		strTime = "" + i;
%>
						<option value="<%=strTime%>"><%=strTime%></option>
<%
	}	
%>	
					</select>시
<!-- 					<select id="insert_date_min" name="insert_date_min" class="select"> -->
<%	/*for(int i = 0 ; i < 60 ; i+=10){
		String strMin = "";
		if(i < 10)	strMin = "0" + i;
		else		strMin = "" + i;
	*/
%>
<%-- 						<OPTION VALUE="<%=STRMIN%>"><%=STRMIN%></OPTION> --%>
<%
	//}	
%>										
<!-- 					</select>분 -->
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">대표규격</td>
				<td colspan="3" class="table_td_contents">
					<input id="stand_good_spec_desc" name="stand_good_spec_desc" type="text" value="" size="" maxlength="100" style="width:95%;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">입찰종료일자</td>
				<td class="table_td_contents">
					<input id="bidenddateday" name="bidenddateday" type="text" style="width:73px;" class="input_text_none" disabled="disabled" />
					<select id="bidenddatetime" name="bidenddatetime" class="select">
<%	for(int i = 0 ; i < 24 ; i++){
		String strTime = "";
		if(i < 10)	strTime = "0" + i;
		else		strTime = "" + i;
%>
						<option value="<%=strTime%>"><%=strTime%></option>
<%
	}	
%>					
					</select>시
<!-- 					<select id="bidenddatemin" name="bidenddatemin" class="select"> -->
<%	/*for(int i = 0 ; i < 60 ; i+=10){
		String strMin = "";
		if(i < 10)	strMin = "0" + i;
		else		strMin = "" + i;
	*/
%>
<%-- 						<option value="<%=strMin%>"><%=strMin%></option> --%>
<%
	//}	
%>										
<!-- 					</select>분 -->
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">투찰시 인증서</td>
				<td class="table_td_contents">
					<select id="is_use_certificate" name="is_use_certificate" style="width:120px;" class="select">
						<option value="0">아니오</option>
						<option value="1">예</option>
					</select></td>
				<td class="table_td_subject">희망가격</td>
				<td class="table_td_contents">
					<input id="hope_sale_price" name="hope_sale_price" type="text" value="" size="" maxlength="30" style="text-align:right;" class="input_text_none" disabled="disabled" /></td>
				<td class="table_td_subject">구분</td>
				<td class="table_td_contents">
					<select id="bidClassify" name="bidClassify">
						<option value="">전체</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">요청사항</td>
				<td colspan="5" class="table_td_contents4">
					<textarea name="bidnote" id="bidnote" cols="45" rows="10" style="width:730px;height:100px;" class="input_text_none" disabled="disabled"></textarea></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일1</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="firstattachseqBid" name="firstattachseqBid" value=""/>
					<input type="hidden" id="attach_file_path1Bid" name="attach_file_path1Bid" value=""/>
					<a href="#"  onclick="javascript:fnAttachFileDownload($('#attach_file_path1Bid').val());">
					<span id="attach_file_name1Bid"></span>
					</a>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일2</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="secondattachseqBid" name="secondattachseqBid" value="" />
					<input type="hidden" id="attach_file_path2Bid" name="attach_file_path2Bid" value="" />
					<a href="#" onclick="javascript:fnAttachFileDownload($('#attach_file_path2Bid').val());">
					<span id="attach_file_name2Bid"></span>
					</a>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>첨부파일3</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="thirdattachseqBid" name="thirdattachseq" value="" />
					<input type="hidden" id="attach_file_path3Bid" name="attach_file_path3Bid" value="" />
					<a href="#" onclick="javascript:fnAttachFileDownload($('#attach_file_path3Bid').val());">
					<span id="attach_file_name3Bid"></span>
					</a>
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
<%	if("ADM".equals(loginUserDto.getSvcTypeCd())) { %>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top" >
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">공급업체 투찰 정보</td>
				<td align="right" class="ptitle">
					<img id="sucButton" src="/img/system/btn_type3_bidSuccess.gif" width="116" height="22" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>" /></td>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>
<tr>
	<td>
		<div id="jqgrid">
			<table id="list"></table>
		</div>
	</td>
</tr>
<% } %>
<tr>
	<td>&nbsp;</td>
</tr>
<tr id="prodTitle">
	<td>
		<!-- 타이틀 시작 -->
		<table width="100%" style="height:27px;" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="20" valign="top" >
					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width:5px;height:5px;" class="bullet_stitle" /></td>
				<td class="stitle">투찰 상품정보</td>
				<td align="right" class="ptitle">
<%-- 					<img id="regButton" src="/img/system/btn_type3_productReg.gif" width="75" height="22" style="cursor: pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_APP")%>"  /></td> --%>
			</tr>
		</table>
		<!-- 타이틀 끝 -->
	</td>
</tr>

<tr id="venProdDetail">
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
				<td class="table_td_subject9">공급업체명</td>
				<td colspan="3" class="table_td_contents">
					<input id="vendornmAuc" name="vendornmAuc" type="text" value="" size="20" maxlength="30" style="width:400px;" class="input_text_none" disabled="disabled" />
					<input id="vendoridAuc" name="vendoridAuc" type="hidden" value="" />
					<input id="bidding_user_idAuc" name="bidding_user_idAuc" type="hidden" value="" /></td>
				<td class="table_td_subject9">상품투찰일자</td>
				<td class="table_td_contents">
					<input id="bidding_dateAuc" name="bidding_dateAuc" type="text" value="" size="20" maxlength="30" class="input_text_none" disabled="disabled" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject9">상품명</td>
				<td colspan="3" class="table_td_contents">
					<input id="good_nameAuc" name="good_nameAuc"  class="input_text_none"type="text" value="" size="20" maxlength="30" style="width:400px;"/></td>
				<td class="table_td_subject9_red" style="border: 1px solid #EA002C; ">투찰금액</td>
				<td class="table_td_contents"  >
					<input id="sale_unit_priceAuc" name="sale_unit_priceAuc" type="text" value="" size="" maxlength="15" style="text-align:right;" requiredNumber /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" >상품규격</td>
				<td colspan="3" class="table_td_contents">
				    <input id="good_spec_descAuc1" name="good_spec_descAuc1"  class="input_text_none" type="text" value="" size="67" maxlength="100" style="text-align:left;" />
			    </td>
				<td class="table_td_subject9">납품소요일</td>
				<td class="table_td_contents">
					<input id="deli_mini_dayAuc" name="deli_mini_dayAuc" type="text"  class="input_text_none" value="" size="15" maxlength="2" style="text-align:right;" onkeydown="return onlyNumber(event)" />일</td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" width="100">제조사</td>
				<td class="table_td_contents">
					<input id="make_comp_nameAuc" name="make_comp_nameAuc" type="text" value="" size="20" maxlength="30" /></td>
				<td class="table_td_subject" width="100">주문단위</td>
				<td class="table_td_contents">
					<select id="orde_clas_codeAuc" name="orde_clas_codeAuc" class="select">
						<option value="선택">선택</option>
<%	@SuppressWarnings("unchecked")
	List<CodesDto> orderUnitCd = (List<CodesDto>)request.getAttribute("orderUnitCd");

	if(bidStateCd != null && bidStateCd.size() > 0){
		for(CodesDto dto : orderUnitCd){
%>
						<option value="<%=dto.getCodeVal1()%>"><%=dto.getCodeNm1()%></option>
<%		
		}
	}
%>						
					</select></td>
				<td class="table_td_subject9" width="100">최소주문수량</td>
				<td class="table_td_contents">
					<input id="deli_mini_quanAuc" name="deli_mini_quanAuc"  class="input_text_none"  type="text" value="" size="20" maxlength="10" style="text-align:right;" onkeydown="return onlyNumber(event)" /></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr style="display: none;">
				<td class="table_td_subject">상품이미지</td>
				<td class="table_td_contents">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td height="25">
								<input id="originalImgPathAuc" name="originalImgPathAuc" type="text" value="" size="30" readonly="readonly"   class="input_text_none" onkeyDown="if(event.keyCode==8) {event.keyCode=0;return false;}" />
								<input id="largeImgPathAuc" name="largeImgPathAuc" type="hidden" value="" />
								<input id="middleImgPathAuc" name="middleImgPathAuc" type="hidden" value="" />
								<input id="smallImgPathAuc" name="smallImgPathAuc" type="hidden" value="" /></td>
						</tr>
						<tr>
							<td colspan="2" height="25">
								<a href="#"><img id="btnAttach" name="btnAttach" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageOK.gif" style="width:75px;height:18px;border:0px;" /></a>
								<a href="#"><img id="btnAttachDel" name="btnAttachDel" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type2_imageDelete.gif" style="width:75px;height:18px;border:0px;" /></a>
							</td>
						</tr>
					</table></td>
				<td class="table_td_subject">대표상품이미지</td>
				<td colspan="2" class="table_td_contents4">
					<table>
						<tr>
							<td valign="bottom">SMALL<br/>
								<a href="#"><img id="SMALL" src="/img/system/imageResize/prod_img_50.gif" alt="SMALL" style="border:0px;" /></a>
							</td>
							<td valign="bottom">MEDIUM<br/>
								<a href="#"><img id="MEDIUM" src="/img/system/imageResize/prod_img_70.gif" alt="MEDIUM" style="border:0px;" /></a>
							</td>
							<td valign="bottom">LARGE<br/>
								<a href="#"><img id="LARGE" src="/img/system/imageResize/prod_img_100.gif" alt="LARGE" style="border:0px;" /></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr  style="display: none;">
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject">상품상세설명</td>
				<td colspan="5" class="table_td_contents4" style="height:50;">
					<textarea id="tx_load_content" cols="80" rows="10" style="height:250px;display:none;"></textarea>
				</td>
			</tr>
			<tr  style="display: none;">
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr  style="display: none;">
				<td class="table_td_subject">상품 동의어</td>
				<td colspan="5" class="table_td_contents">
					<table width="98%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><input id="good_same_wordAuc1" name="good_same_wordAuc1" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
							<td><input id="good_same_wordAuc2" name="good_same_wordAuc2" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
							<td><input id="good_same_wordAuc3" name="good_same_wordAuc3" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
							<td><input id="good_same_wordAuc4" name="good_same_wordAuc4" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
							<td><input id="good_same_wordAuc5" name="good_same_wordAuc5" type="text" value="" size="20" maxlength="20" style="width:95%;" /></td>
						</tr>
					</table></td>
			</tr>
			<tr>
				<td colspan="6" height="1" bgcolor="eaeaea"></td>
			</tr>
			<tr>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>
								<button id="btnAttach1" name="btnAttach1" type="button" class="btn btn-darkgray btn-xs"> 첨부파일1 </button>
							</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="firstattachseq" name="firstattachseq" value=""/>
					<input type="hidden" id="attach_file_path1" name="attach_file_path1" value=""/>
					<a href="#" onclick="javascript:fnAttachFileDownload($('#attach_file_path1').val());">
					<span id="attach_file_name1"></span>
					</a>
					<button id="btnAttachDel1" name="btnAttachDel1" type="button" class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('firstattachseq');" style="padding: 1px;"> <i class="fa fa-close"></i></button>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>
								<button id="btnAttach2" name="btnAttach2" type="button" class="btn btn-darkgray btn-xs"> 첨부파일2 </button>
							</td>							
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="secondattachseq" name="secondattachseq" value=""/>
					<input type="hidden" id="attach_file_path2" name="attach_file_path2" value=""/>
					<a href="#" onclick="javascript:fnAttachFileDownload($('#attach_file_path2').val());">
					<span id="attach_file_name2"></span>
					</a>
					<button id="btnAttachDel2" name="btnAttachDel2" type="button" class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('secondattachseq');" style="padding: 1px;"> <i class="fa fa-close"></i></button>
				</td>
				<td class="table_td_subject" style="white-space:nowrap;">
					<table>
						<tr>
							<td>
							<button id="btnAttach3" name="btnAttach3" type="button" class="btn btn-darkgray btn-xs"> 첨부파일3 </button>
							</td>
						</tr>
					</table>
				</td>
				<td class="table_td_contents">
					<input type="hidden" id="thirdattachseq" name="thirdattachseq" value=""/>
					<input type="hidden" id="attach_file_path3" name="attach_file_path3" value=""/>
					<a href="#" onclick="javascript:fnAttachFileDownload($('#attach_file_path3').val());">
					<span id="attach_file_name3"></span>
					</a>
					<button id="btnAttachDel3" name="btnAttachDel3" type="button" class="btn btn-darkgray btn-xs" onclick="javascript:fnAttachDel('thirdattachseq');" style="padding: 1px;"> <i class="fa fa-close"></i></button>
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
	<td align="center">
	&nbsp;&nbsp;
		<button id="btnTenNewProduct" name="btnTenNewProduct" type="button" class="btn btn-darkgray btn-sm"><i class="fa fa-paper-plane-o"></i> 상품투찰 </button>
		
<%-- 		&nbsp;&nbsp;<img id="btnTenNewProduct" src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_productTender.gif" style="width:85px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_SAVE")%>" />&nbsp;&nbsp;<img id='btnCommonClose' src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type5_close.gif" style="width:65px;height:23px;cursor:pointer;<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>" />&nbsp;&nbsp; --%>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>

<!-------------------------------- Dialog Div Start -------------------------------->
<!-------------------------------- Dialog Div End -------------------------------->
<input type="hidden" id="bidEndDate" name="bidEndDate" value=""/>
<input type="hidden" id="bidInsertDate" name="bidInsertDate" value=""/>
</form>
</div>
<%@ include file="./newProductTenderMajorDiv.jsp" %>
</body>
</html>