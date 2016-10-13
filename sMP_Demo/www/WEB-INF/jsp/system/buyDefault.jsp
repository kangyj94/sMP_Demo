<%@ page import="java.util.HashMap"%>
<%@ page import="org.springframework.ui.ModelMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="java.util.Map"%>
<%@ page import="kr.co.bitcube.board.dto.BoardDto"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto"%>
       
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemIncludeNoLoading.jsp" %>
<%
	List<Map<String, Object>> cate                = (List<Map<String, Object>>)session.getAttribute("cate");
	List<BoardDto>            noticeList          = (List<BoardDto>)request.getAttribute("noticeList");
	List<BoardDto>            emergencyList       = (List<BoardDto>)request.getAttribute("emergencyList");
	List<Object>              mainDisplayList     = (List<Object>)request.getAttribute("mainDisplayList");	//메인 전시상품
	List<Object>              mainInvoiceList     = (List<Object>)request.getAttribute("mainInvoiceList");	//메인 세금계산서
	Map<String,Object>        smileEvalInfo       = (Map<String, Object>)request.getAttribute("smileEvalInfo");
	Map<String,Object>        mainNoneSettleMap   = (Map<String, Object>)request.getAttribute("mainNoneSettleMap");	//메인 미결제대금
	Map<String,Object>        mainExpireSettleMap = (Map<String, Object>)request.getAttribute("mainExpireSettleMap");	//메인 최근만기도래금
	Map<String,Object>        mainOverExpireSettleMap = (Map<String, Object>)request.getAttribute("mainOverExpireSettleMap");	//메인 만기경과금액
	Map<String, String>       managerUserInfo     = (Map<String, String>)request.getAttribute("managerUserInfo");
	String                    noneSettleAmount    = "0";
	String                    nonePay             = "0";
	String                    expirationDate      = "";
	String                    noneOverSettleAmount= "0";
	
	if(mainNoneSettleMap!=null) {
		noneSettleAmount = CommonUtils.getIntString(mainNoneSettleMap.get("NONE_PAY_SUM"));
		noneSettleAmount = ("".equals(noneSettleAmount)) ? "0" : noneSettleAmount;
	}
	
	if(mainExpireSettleMap!=null) {
		nonePay = CommonUtils.getIntString(mainExpireSettleMap.get("NONE_PAY"));
		nonePay = ("".equals(nonePay)) ? "0" : nonePay;
		expirationDate = "("+CommonUtils.getString(mainExpireSettleMap.get("EXPIRATION_DATE"))+")";
	}
	
	if(mainOverExpireSettleMap!=null) {
		noneOverSettleAmount = CommonUtils.getIntString(mainOverExpireSettleMap.get("OVER_NONE_PAY"));
		noneOverSettleAmount = ("".equals(noneOverSettleAmount)) ? "0" : noneOverSettleAmount;
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>SK텔레시스 - 성공기업의 Prime Business Partner!</title>
<link rel="stylesheet" type="text/css" href="/css/Global.css">
<link rel="stylesheet" type="text/css" href="/css/Default.css">
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>

<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/jquery.bxslider/jquery.bxslider.min.js"></script>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/jq/jquery.bxslider/jquery.bxslider.css" rel="stylesheet" />
<style type="text/css">
#smilePopJqm {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -320px;
    width: 0px;
    border: 0px;
    padding: 0px;
    height: 0px;
}
.jqmOverlay { background-color: #000; }
#smilePopJqm {
    position: absolute;
    top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>
<script>
$(document).ready(function() {
	$("#divGnb").mouseover(function () {$("#snb").show();});
	$("#divGnb").mouseout(function () {$("#snb").hide();});
	$("#snb").mouseover(function () {$("#snb").show();});
	$("#snb").mouseout(function () {$("#snb").hide();});
	$('.bxslider').bxSlider({
<%
	if(mainDisplayList!=null && mainDisplayList.size() > 1){
		out.println("auto: true, pager: false");
	}
	else{
		out.println("pager: false");
	}
%>
	});
	
	fnContractToDoList();
});

function fnCategoryDivShow(id){
	$.each($(".CategoryDiv"), function(){
		$(this).attr("style", "display:none");
	});
	
	var position        = $("#" + id + "li").position();
	var top             = position.top + 70;
	var viewPercentInfo = null;
	var vertical        = null;
	var height          = null;
	
	document.getElementById(id).style.top     = top + "px";
	document.getElementById(id).style.display = "block";
	
	height          = $("#" + id).height();
	viewPercentInfo = fnViewPercent(id);
	vertical        = viewPercentInfo.vertical;
	
	if(vertical < 100){
		top = (top - (height * (100 - vertical)) / 100) - 30;
		
		if(top < 0){
			top = 0;
		}
		
		document.getElementById(id).style.top = top + "px";
	}
}

function fnSearchCate(topCateId, midCateId, dtlCateId){
	var srcCateId = topCateId;
	var params    = "";
	
	if(midCateId != ''){
		srcCateId = midCateId;
	}
	
	if(dtlCateId != ''){
		srcCateId = dtlCateId;
	}
	
	params += "searchType=N";
	params += "&inputWord=";
	params += "&prevWord=";
	params += "&srcCateId=" + srcCateId;
	params += "&setCateId=" + topCateId;
	params += "&pCnt=30";
	params += "&pIdx=1";
	
	fnDynamicForm("/buyProduct/productResultList.sys", params, "");
}

function fnNoticeDetailPop(boardNo){
	var params = "board_No=" + boardNo;
	
	window.open("", 'noticeDetailPop', 'width=720, height=510, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/noticeDetail.sys", params, "noticeDetailPop");
}

function vocGo(){
	window.open("", 'requestManageWrite', 'width=720, height=600, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/board/requestManageWrite.sys", "", "requestManageWrite");
}

function fnReloadGrid(){}

//세금계산서
function fnEBill(pubCode){
	$("#pubCode").val(pubCode);
	if($.trim($("#pubCode").val() != "")){
		var iMyHeight;
		width = (window.screen.width-635)/2;
		if(width<0)width=0;
		iMyWidth = width;
		height = 0;
		if(height<0)height=0;
		iMyHeight = height;
		
		window.open("http://<%=Constances.EBILL_URL%>/jsp/directTax/TaxViewIndex.jsp?pubCode="+pubCode+"&docType=T&userType=R", "taxInvoice", "resizable=no,  scrollbars=no, left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",width=700px, height=760px");
		
		$("#pubCode").val("");
		taxInvoice.focus();
	} else { jq( "#dialogSelectRow" ).dialog(); }   
}
//거래명세서
function fnEPay(saleSequNumb){
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "BchParticulars"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;
	oReport.param("saleSequNumb").value = saleSequNumb;
	
	oReport.title = "거래명세서"; // 제목 세팅
	oReport.open();
}

/**
 * 안전거래용품 인증서
 */
function eSaveCertificate(saleSequNumb){
	var skCoNm      = '<%=Constances.EBILL_CONAME%>';
	var skBizNo		= '<%=Constances.EBILL_COREGNO%>';
	var skCeoNm 	= '<%=Constances.EBILL_COCEO%>';
	var skAddr  	= '<%=Constances.EBILL_COADDR%>';
	var skBizType	= '<%=Constances.EBILL_COBIZTYPE%>';
	var skBizSub	= '<%=Constances.EBILL_COBIZSUB%>';
	var saleSequNumb= saleSequNumb;
	var oReport = GetfnParamSet(); // 필수
	oReport.rptname = "BchSaveCertificate"; // reb 파일이름
	
	oReport.param("skCoNm").value 		= skCoNm;
	oReport.param("skBizNo").value 		= skBizNo;
	oReport.param("skCeoNm").value 		= skCeoNm;
	oReport.param("skAddr").value 		= skAddr;
	oReport.param("skBizType").value 	= skBizType;
	oReport.param("skBizSub").value 	= skBizSub;
	oReport.param("saleSequNumb").value = saleSequNumb;
	
	oReport.title = "안전거래인증서"; // 제목 세팅
	oReport.open();		
}

//대체이미지
function imageMainOnError(imgObj) {
	imgObj.onerror = "";
	imgObj.src = "/img/contents/defaultMain.jpg";
	return true;
}

</script>

<%-- 스마일 통계 관련 스크립트 --%>
<%
	if(smileEvalInfo != null && (Boolean)smileEvalInfo.get("isSmile")==true ){
%>
<script type="text/javascript">
$(document).ready(function(){
	fnSmileEvalPop();
});

function fnSmileEvalPop(){
	$('#smilePopJqm').jqm({modal:true});
	$('#smilePopJqm').jqm().jqDrag('#smilePopDrag');
	$('#smilePopJqm').jqmShow();

}
function fnSmileEval(){
	var smileArr= $(".smileId");
	var cnt = smileArr.length; 
	var smileIdArr		= new Array();
	var targetSvcCdArr	= new Array();
	var evalArr			= new Array();
	var id;

	for( var i=0 ; i < cnt ; i++){
		id = smileArr[i].value ;
		if( $("input[name*=evalA_"+id+"]").is(":checked")==false ){
			alert("모든 설문 문항에 대한 답변을 처리하여 주시기 바랍니다.");
			return;
		}
		smileIdArr.push( $("#smileId_"+id).val()  );
		targetSvcCdArr.push( $("#targetSvcCd_"+id).val() );
		evalArr.push( $("input[name=evalA_"+id+"]:checked").val() );
	}	
	
	if( smileIdArr.length != cnt || targetSvcCdArr.length != cnt || evalArr.length != cnt  ){
		alert( "데이터가 올바르지 않습니다.");
		return;
	}


    $("#smilePopJqm").jqmHide();
	$.ajax({
		url : "/evaluate/setSmileEval.sys",
		type : "post",
		dataType : "json",
		data : {
			smileIdArr : smileIdArr ,
			targetSvcCdArr : targetSvcCdArr,
			evalArr : evalArr,
			targetVenId : '<%= CommonUtils.getString( smileEvalInfo.get("targetVenId") ) %>'
		},
		success : function( arg ){
			var result = arg.customResponse;
			if( result.success == true ){
				alert( "설문에 참여하여 주셔서 감사합니다." );
			}else{
				alert( result.message );
			}
		}
	});	
}
</script>
<%
	}
%>
<%-- /스마일 통계 관련 스크립트 --%>

</head>
<form id="ebillPopFrm" name="ebillPopFrm" onsubmit="return false;">
	<input id="pubCode" name="pubCode" type="hidden"/>
	<input id="docType" name="docType" type="hidden" value="T"/>
	<input id="userType" name="userType" type="hidden" value="R"/>
</form>

<body class="mainBg">
  <div id="divWrap">
  	<!-- header -->
	<%@include file="/WEB-INF/jsp/system/treeFrame/buyHeader.jsp" %>
  	<!-- /header -->
    <hr>
		<div id="divBody">
        	<div id="divSub">
            	<jsp:include page="/WEB-INF/jsp/common/front/orderStepIncludeBuy.jsp" flush="false" />
           			<div id="CategoryAll" class="CategoryDiv" style="display:none;" onmouseout="javascript:document.getElementById('CategoryAll').style.display='none';" onmouseover="javascript:document.getElementById('CategoryAll').style.display='block';">
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              dtlCateName       = null;
		String              dtlCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
%>
		<ul>
<%
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			dtlCateName = CommonUtils.getString(cateInfo.get("DTL_CATE_NAME"));
			dtlCateId   = CommonUtils.getString(cateInfo.get("DTL_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작 
%>
							<li class="OneDepht"><%=topCateName %></li>
<%
			}
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
							<li>
								<dl>
									<dt><%=midCateName %></dt>
<%
			}
%>
									<dd onclick="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '<%=dtlCateId %>');">
										<p>
											<a href="javascript:void(0);"><%=dtlCateName %></a>
               							</p>
               						</dd>
<%
			if((i != 0) && ((i % 15) == 0)){
%>
								</dl>
							</li>
						</ul>
						<ul>
							<li>
								<dl>
<%
			}

			if(nextMidCateId.equals(midCateId) == false){ // 중분류 종료
%>
								</dl>
<%
			}

			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
							</li>
<%
			}
		}
%>
						</ul>
<%
	}
%>
           			</div>
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              topCateCd         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              dtlCateName       = null;
		String              dtlCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
		int                 cateCount         = 0;
	
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			topCateCd   = CommonUtils.getString(cateInfo.get("TOP_CATE_CD"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			dtlCateName = CommonUtils.getString(cateInfo.get("DTL_CATE_NAME"));
			dtlCateId   = CommonUtils.getString(cateInfo.get("DTL_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작
				cateCount = 0;
%>
				<div id="Category<%=topCateCd %>" class="CategoryDiv" style="display:none;" onmouseout="javascript:document.getElementById('Category<%=topCateCd %>').style.display='none';" onmouseover="javascript:document.getElementById('Category<%=topCateCd %>').style.display='block';">
						<ul>
							<li class="OneDepht"><%=topCateName %></li>
<%
			}
			
			cateCount++;
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
							<li>
								<dl>
									<dt><%=midCateName %></dt>
<%
			}
%>
									<dd onclick="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '<%=dtlCateId %>');">
										<p>
											<a href="javascript:void(0);"><%=dtlCateName %></a>
               							</p>
               						</dd>
<%
			if((cateCount != 0) && ((cateCount % 15) == 0)){
%>
								</dl>
							</li>
						</ul>
						<ul>
							<li>
								<dl>
<%
			}

			if(nextMidCateId.equals(midCateId) == false){ // 중분류 종료
%>
								</dl>
							</li>
<%
			}

			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
						</ul>
           			</div>
<%
			}
		}
	}
%>
					<div id="divCategory">
<!-- 						<h2 onmouseover="javascript:fnCategoryDivShow('CategoryAll');" id="CategoryAllli" onmouseout="javascript:document.getElementById('CategoryAll').style.display='none';"> -->
						<h2>
							<img src="/img/layout/category_all.gif" />
						</h2>
							<ul>
<%
	if(cate != null){
		String              topCateName       = null;
		String              topCateId         = null;
		String              topCateCd         = null;
		String              midCateName       = null;
		String              midCateId         = null;
		String              beforeTopCateId   = null;
		String              beforeMidCateId   = null;
		String              nextTopCateId     = null;
		String              nextMidCateId     = null;
		Map<String, Object> cateInfo          = null;
		Map<String, Object> beforeCateInfo    = null;
		Map<String, Object> nextCateInfo      = null;
		int                 i                 = 0;
		int                 cateSize          = cate.size();
		int                 lastIndex         = cateSize - 1;
	
		for(i = 0 ; i < cateSize ; i++){
			cateInfo    = cate.get(i);
			topCateName = CommonUtils.getString(cateInfo.get("TOP_CATE_NAME"));
			topCateId   = CommonUtils.getString(cateInfo.get("TOP_CATE_ID"));
			topCateCd   = CommonUtils.getString(cateInfo.get("TOP_CATE_CD"));
			midCateName = CommonUtils.getString(cateInfo.get("MID_CATE_NAME"));
			midCateId   = CommonUtils.getString(cateInfo.get("MID_CATE_ID"));
			
			if(i == 0){
				beforeTopCateId = "";
				beforeMidCateId = "";
			}
			else{
				beforeCateInfo  = cate.get(i - 1);
				beforeTopCateId = CommonUtils.getString(beforeCateInfo.get("TOP_CATE_ID"));  
				beforeMidCateId = CommonUtils.getString(beforeCateInfo.get("MID_CATE_ID"));  
			}
			
			if(i == lastIndex){
				nextTopCateId = "";
				nextMidCateId = "";
			}
			else{
				nextCateInfo  = cate.get(i + 1);
				nextTopCateId = CommonUtils.getString(nextCateInfo.get("TOP_CATE_ID"));
				nextMidCateId = CommonUtils.getString(nextCateInfo.get("MID_CATE_ID"));
			}
			
			if(beforeTopCateId.equals(topCateId) == false){ // 대분류 시작
%>
				<li onmouseover="javascript:fnCategoryDivShow('Category<%=topCateCd %>');" id="Category<%=topCateCd %>li" onmouseout="javascript:document.getElementById('Category<%=topCateCd %>').style.display='none';">
              		<span ><%=topCateName %></span>
              	</li>
              	<li>
              		<div style="line-height: 2.0em;">
<%
			}
			
			if(beforeMidCateId.equals(midCateId) == false){ // 중분류 시작
%>
						<a href="javascript:fnSearchCate('<%=topCateId %>','<%=midCateId %>', '');" ><%=midCateName %></a>
<%
			}
			
			if(nextTopCateId.equals(topCateId) == false){ // 대분류 종료
%>
					</div>
				</li>
<%
			}
		}
	}

	if(managerUserInfo != null){
		String userNm = managerUserInfo.get("userNm");
		String tel    = managerUserInfo.get("tel");
		String email  = managerUserInfo.get("email");
%>
				<li style="background-image:url(/img/layout/cs_center.gif); height: 70px; text-align: right; padding-right: 1px; background-repeat: no-repeat;">
					<div style="line-height: 15px; color: #F67F25; font-size:15px; font-weight: bold;"><%=tel %></div>
					<div style="line-height: 10px; font-size:15px; font-weight: bold;"><%=email %></div>
					<div style="line-height: 10px; font-weight: bold; color: black;"><font style="color: #888;">담당자 :</font> <%=userNm %></div>
				</li>
<%
	}
%>
			</ul>
		</div>
        <div id="divContainer">
			<div id="vendorMain">
				<div class="visual">
					<ul class="bxslider">
<%	if(mainDisplayList==null || mainDisplayList.size()==0) { %>
						<li><img src="/img/contents/defaultMain.jpg" style="width: 825px; height: 270px;" /></li>
<%	
	} else {
		for(Object obj : mainDisplayList) {
			Map<String,Object> displayMap = (Map<String,Object>)obj;
			String displayGoodIdenNumb = CommonUtils.getString(displayMap.get("GOOD_IDEN_NUMB"));
			String displayMainPath = CommonUtils.getString(displayMap.get("ATTACH_FILE_PATH"));
%>
						<li>
							<a href="javascript:fnProductDetailPop('<%=displayGoodIdenNumb %>', '');">
								<img src="/common/attachFileDownload.sys?attachFilePath=<%=displayMainPath %>" style="width: 825px; height: 270px;" onerror="return imageMainOnError(this);" />
							</a>
						</li>
<%	
		}
	}
%>
					</ul>
				</div>
				<div class="BoxCont mgr_15">
					<div class="Notice">
						<h2>공지사항 <span>
							<a href="/menu/board/community/noticeListBuy.sys?_menuCd=BUY_COMM_NOTI" target="_self">
								<img src="/img/contents/main_more.gif" />
							</a>
						</span></h2>
						<dl class="mgt_5">
<%
	if(noticeList != null){
		BoardDto noticeInfo     = null;
		String   title          = null;
		String   regDateTime    = null;
		String   boardNo        = null;
		String   isNew          = null;
		String   importantYn    = null;
		int      noticeListSize = noticeList.size();
		int      i              = 0;
		
		for(i = 0; i < noticeListSize; i++){
			noticeInfo  = noticeList.get(i);
			title       = noticeInfo.getTitle();
			regDateTime = noticeInfo.getRegi_Date_Time();
			boardNo     = noticeInfo.getBoard_No();
			isNew       = noticeInfo.getIsNew();
			importantYn = noticeInfo.getImportantYn();
			title       = CommonUtils.getByteSubstring(title, 50, "..."); // 제목 길이 조정
			
			if("Y".equals(importantYn)){
				isNew = "N";
			}
%>
							<dt>
<%
			if("Y".equals(isNew)){
%>
								<img src="/img/contents/icon_notice02.gif" />
<%
			}

			if("Y".equals(importantYn)){
%>							
								<img src="/img/contents/icon_notice03.gif" />
<%
			}
%>
								<a href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
							</dt>
							<dd><%=regDateTime %></dd>
<%
		}
	}
%>
						</dl>
					</div>
				</div>
				<div class="BoxCont">
					<h2>세금계산서 <span style="position:absolute; margin-top:10px; margin-left:290px;">
						<a href="/menu/ebill/ebillBuyList.sys?_menuCd=BUY_ADJUST_BILL" target="_self">
							<img src="/img/contents/main_more.gif" />
						</a>
					</span></h2>
					<table width="100%">
						<colgroup>
							<col width="25%" />
							<col width="20%" />
							<col width="19%" />
							<col width="18%" />
							<col width="18%" />
						</colgroup>
						<tr>
							<th>발행일</th>
							<th>금액</th>
							<th>세금계산서</th>
							<th>거래내역서</th>
							<th>안전용품구매증명서</th>
						</tr>

<%
	Map<String, Object> mainInvoiceInfo     = null;
	String              invoiceAmount       = null;
	String              invoiceDay          = null;
	String              pubCode             = null;
	String              saleSequNum         = null;
	int                 mainInvoiceListSize = 0;
	int                 ii                  = 0;
	
	if(mainInvoiceList != null){
		mainInvoiceListSize = mainInvoiceList.size();
	}
	
	for(ii = 0; ii < mainInvoiceListSize; ii++){
		mainInvoiceInfo = (Map<String, Object>)mainInvoiceList.get(ii);
		invoiceAmount   = CommonUtils.getString(mainInvoiceInfo.get("SALE_TOTA_AMOU")) ;
		invoiceDay      = CommonUtils.getString(mainInvoiceInfo.get("CLOS_SALE_DATE") );
		pubCode         = CommonUtils.getString(mainInvoiceInfo.get("PUBCODE") );
		saleSequNum     = CommonUtils.getString(mainInvoiceInfo.get("SALE_SEQU_NUMB") );
		invoiceDay      = CommonUtils.nvl(invoiceDay, "&nbsp;");
		invoiceAmount   = CommonUtils.getIntString(invoiceAmount);
%>
						<tr>
							<td><%=invoiceDay %></td>
							<td style="text-align: right;"><%=invoiceAmount %></td>
							<td>
<%
		if("".equals(invoiceAmount) == false) {
%>
								<a href='javascript:void(0);'>
									<img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick="javaScript:fnEBill('<%=pubCode %>')"/>
								</a>
<%
		}
%>
							</td>
							<td>
<%
		if("".equals(invoiceAmount) == false) {
%>
								<a href='javascript:void(0);'>
									<img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick="javaScript:fnEPay('<%=saleSequNum %>')"/>
								</a>
<%
		}
%>
							</td>
							<td>
<%
		if("".equals(invoiceAmount) == false) {
%>
                                <a href='#'>
                                	<img src='/img/system/icon/ico_annex.gif' style='border:0;' onclick="javaScript:eSaveCertificate('<%=saleSequNum %>')"/>
                                </a>
<%
		}
%>
							</td>
						</tr>
<%
	}

	for(ii = (3 - mainInvoiceListSize); ii > 0; ii--){
%>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
<%
	}
%>
					</table>
					<h2 class="mgt_10">자재대금 결제정보 <span style="position:absolute; margin-top:10px; margin-left:290px;">
						<a href="/BuyAdjust/adjustBuyBondsOccurrence.sys?_menuCd=BUY_ADJUST_DEBT" target="_self">
							<img src="/img/contents/main_more.gif" />
						</a>
					</span></h2>
					<ul>
						<li><img src="/img/contents/main_bullet01.gif" /> 총 미결제 대금 : <strong class="col03"><%=noneSettleAmount %> </strong>원</li>
						<li><img src="/img/contents/main_bullet01.gif" /> 만기 경과 대금 : <strong class="col03"><%=noneOverSettleAmount %> </strong>원</li>
						<li><img src="/img/contents/main_bullet01.gif" /> 최근 만기 도래대금 : <strong class="col03"><%=nonePay %> </strong>원 <%=expirationDate %></li>
					</ul>
					<div style="position: relative; top: -45px;">
						<h2><span class="f12" style="line-height: 1.3em; text-align: left;">국민은행<br/>295401-01-159395<br/>[SK텔레시스]</span></h2>
					</div>
				</div>
				<ul class="banner">
					<li>
						<img src="/img/contents/main_banner01.gif" usemap="#Map" border="0" />
						<map name="Map" id="Map">
							<area shape="rect" coords="104,13,171,32" href="javascript:fnContractView('B');" />
							<area shape="rect" coords="102,32,173,50" href="javascript:fnContractView('S');" />
						</map>
						<input type="hidden" id="contractBView" />
						<input type="hidden" id="contractSView" />
					</li>
					<li>
						<a href="javascript:alert('준비중입니다.');">
							<img src="/img/contents/main_banner02.gif" />
						</a>
					</li>
					<li>
						<a href="javascript:vocGo();">
							<img src="/img/contents/main_banner03.gif" />
						</a>
					</li>
					<li>
						<a href="https://www.docusharp.com/member/join.jsp" target="_blank">
							<img src="/img/contents/main_banner04.gif" />
						</a>
					</li>
					<li>
						<a href="javascript:window.open('http://113366.com/okplaza','remoteManagePop', 'width=950, height=700, scrollbars=yes, status=no, resizable=no');void(0);">
							<img src="/img/contents/main_banner05_1.gif" />
						</a>
					</li>
					<li>
						<a href="/proposal/viewProposalListBuy.sys?_menuCd=BUY_OFFER_NEW" target="_self">
							<img src="/img/contents/main_banner06_buy.gif" />
						</a>
					</li>
				</ul>
				<div class="Alarm">
					<div class="slide" style="width: 645px;">
						<marquee direction="left" onmouseover=stop() onmouseout=start()>
<%
	if(emergencyList != null){
		BoardDto noticeInfo        = null;
		String   title             = null;
		String   boardNo           = null;
		int      emergencyListSize = emergencyList.size();
		int      i                 = 0;
		
		for(i = 0; i < emergencyListSize; i++){
			noticeInfo  = emergencyList.get(i);
			title       = noticeInfo.getTitle();
			boardNo     = noticeInfo.getBoard_No();
%>

							<a style="color:#002060;font-weight:bold" href="javascript:fnNoticeDetailPop('<%=boardNo %>');"><%=title %></a>
							<img src="/img/contents/icon_new.png" />
							&nbsp;&nbsp;&nbsp;
<%
		}
	}
%>
						</marquee>
					</div>
				</div>
			</div>
		</div>
		<!--컨텐츠(E)-->
		</div>
			<jsp:include page="/WEB-INF/jsp/common/front/quickMenuIncludeBuy.jsp"  flush="false" />
		</div>
		<hr>
	</div>
	<%--업체평가 팝업 --%>
<%if( smileEvalInfo != null && (Boolean)smileEvalInfo.get("isSmile")==true ){ %>
	<div id="smilePopJqm">	
		<div id="divPopup" style="width:600px;">
			<div id="smilePopDrag">
				<h1>스마일 지수 조사<a href="#;"></a></h1>
			</div>
			<div class="popcont">
			<p class="mgb_10"><img src="/img/contents/img_smile.gif" /></p>
				<div class="GridList">
					<table>
						<colgroup>
							<col width="120px" />
							<col width="auto" />
							<col width="120px" />
						</colgroup>
						<tr>
							<th>조사영역</th>
							<th colspan="2">설문내용</th>
						</tr>
<%
		List<Map<String,Object>> smileList = (List<Map<String,Object>>)smileEvalInfo.get("smileList");
		Map<String,Object> smile = null;
		String smileId = null;
		if( smileList  != null && smileList.size() > 0){
			int admCnt = (Integer)smileEvalInfo.get("admCnt");
			int venCnt = (Integer)smileEvalInfo.get("venCnt") ;
			for( int i=1 ; i < smileList.size()+1 ; i++){
				smile = (HashMap<String,Object>)smileList.get(i-1);
				smileId = CommonUtils.getString( smile.get("SMILE_ID") );
%>
<%			if( smile.get("TARGET_SVCTYPECD").equals("ADM")== true){ %>
				<tr>
<% 				if( i == 1 ){%>
					<td rowspan="<%=admCnt%>" align="center">
						<strong>SKTS</strong>
					</td>
<%				}%>
					<td>
						<p><%=CommonUtils.getString( smile.get("EVAL_CONTENTS")) %></p>
						<input type="hidden" id="smileId_<%=smileId %>"  name="smileId_<%=smileId %>" class="smileId" value="<%=smileId %>"/>
						<input type="hidden" id="targetSvcCd_<%=smileId %>" name="targetSvcCd_<%=smileId %>" value="<%=smile.get("TARGET_SVCTYPECD")%>"></input>			
					</td>
					<td align="center">
						<input type="radio" name="evalA_<%=smileId %>"  value="100" /> <label for="radio">Yes</label> 
						<input type="radio" name="evalA_<%=smileId %>"  value="0" /> <label for="radio">No</label>
					</td>
				</tr>
<%			}else{ //ven 
					if( (Boolean)smileEvalInfo.get("isRece")==false ) {
						break;
					}
%>
				<tr>
<%					if( i == (admCnt+1) ){	%>
					<td rowspan="<%=venCnt %>" align="center">
						<strong><%= CommonUtils.getString( smileEvalInfo.get("targetVenNm") ) %></strong>					 
					</td>
<%					}%>
					<td>
						<p><%=CommonUtils.getString( smile.get("EVAL_CONTENTS")) %></p>
						<input type="hidden" id="smileId_<%=smileId %>"  name="smileId_<%=smileId %>" class="smileId" value="<%=smileId %>"/>
						<input type="hidden" id="targetSvcCd_<%=smileId %>" name="targetSvcCd_<%=smileId %>" value="<%=smile.get("TARGET_SVCTYPECD") %>"></input>			
					</td>
					<td align="center">
						<input type="radio" name="evalA_<%=smileId %>"  value="100" /> <label for="radio">Yes</label> 
						<input type="radio" name="evalA_<%=smileId %>"  value="0" /> <label for="radio">No</label>
					</td>
				</tr>
<%			}// end of else
		}//end of for
	}
%>
					</table>
				</div>
				<p class="col02 mgt_5">고객님의 작은 목소리를 경청 하겠습니다. 참여해 주셔서 감사합니다.</p>
				<div class="Ar mgt_10">
					<button class="btn btn-darkgray btn-xs"  onclick="javascript:fnSmileEval();"> 보내기</button>
				</div>
			</div>
		</div>
	</div>
<% } %>		
	<%--/업체평가 팝업 --%>
</body>
<%@ include file="/WEB-INF/jsp/product/product/buyProductDetailPop.jsp" %>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="/RexServer30/rexscript/getscript.jsp?f=rexpert_properties"></script>
<script type="text/javascript">
function fnContractToDoList(){
	$.post(
		"/common/contractToDoList.sys",
		{
			borgId:"<%=loginUserDto.getBorgId()%>"
		},
		function(arg){
			var svcTypeCd	= arg.svcTypeCd;
			var list		= arg.list;
			var listLength	= list.length;
			var i           = 0;
			var listInfo    = null;
			var classify    = null;
			var version     = null;
			
			if(listLength > 0){
				for(i = 0; i < listLength; i++){
					listInfo = list[i];
					classify = listInfo.CONTRACT_CLASSIFY;
					version  = listInfo.CONTRACT_VERSION;
					
					if("S" == classify){
						document.getElementById("contractSView").value = version;
					}
					else if("B" == classify){
						document.getElementById("contractBView").value = version;
					}
				}
			}
		},
		"json"
	);
}

function fnContractView(contractClassify) {
	var params          = 'svcTypeCd=BUY';
	var contractVersion = null;
	
	if("S" == contractClassify){
		contractVersion = document.getElementById("contractSView").value;
	}
	else if("B" == contractClassify){
		contractVersion = document.getElementById("contractBView").value;
	}
	
	params = params + '&contractVersion='+contractVersion;
	
	window.open('', 'popContractDetail', 'width=917, height=720, scrollbars=yes, status=no, resizable=no');
	
	fnDynamicForm("/common/popContractDetail.sys", params, "popContractDetail");
}


</script>
<!-- 설문조사 팝업 처리 시작 -->
<div id="pollPop"></div>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqModal.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL%>/jq/js/src/jqDnR.js" type="text/javascript"></script>
<script type="text/javascript">
$(function() {
    $.ajaxSetup ({
        cache: false
    });
    $('#pollPop').load('/board/poll/popup.sys');
});
</script>
<!-- 설문조사 팝업 처리 끝 -->
</html>