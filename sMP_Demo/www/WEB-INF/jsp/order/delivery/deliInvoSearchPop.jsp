<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="kr.co.bitcube.common.dto.CodesDto" %>
<%@ page import="java.util.List"%>
<%@ page import="kr.co.bitcube.common.dto.LoginUserDto" %>
<%
	String _menuId = "".equals(CommonUtils.getString(request.getParameter("_menuId"))) ? CommonUtils.getString(request.getAttribute("_menuId")) : CommonUtils.getString(request.getParameter("_menuId"));
	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-180 + Number(gridHeightResizePlus)";

	LoginUserDto loginUserDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
	@SuppressWarnings("unchecked")	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>)request.getAttribute("useActivityList");
    String srcOrdeIdenNumb = (String)request.getAttribute("orde_iden_numb");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
var jq = jQuery;
$(document).ready(function() {
});
</script>

</head>
<body>
<form id="frm" name="frm">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<!-- 타이틀 시작 -->
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr valign="top">
							<td width="20" valign="middle"><img src="/img/system/bullet_ptitle1.gif" width="14" height="15" /></td>
							<td height="29" class='ptitle'>택배 조회</td>
						</tr>
					</table> 
					<!-- 타이틀 끝 -->
				</td>
			</tr>
            <tr>
               <td colspan="6" class="table_top_line"></td>
            </tr>
            <tr>
               <td colspan="6">&nbsp;</td>
            </tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
<div id="dialogSelectRow" title="Warning" style="display:none;font-size: 12px;color: red;">
	<p>처리할 데이터를 선택 하십시오!</p>
</div>





        <!-- 택배조회Coll -->
        <style type="text/css">
#deliveryColl .collTitle {
	margin-bottom: 16px;
}

#deliveryColl .select_box {
	border: 1px solid #7f9db7;
	width: 135px;
	height: 20px;
	font-size: 12px;
}

#deliveryColl .inp_txt {
	width: 140px;
	height: 14px;
	padding: 4px 0 3px 2px;
	border-top: 1px solid #ababab;
	border-left: 1px solid #ababab;
	border-bottom: 1px solid #ccc;
	border-right: 1px solid #ccc;
	font-size: 12px;
	line-height: 14px;
}

#deliveryColl .wrap_inquiry {
	padding-bottom: 15px;
	border: 1px solid #e8e8e8;
	background: #f9f9f9;
}

#deliveryColl .wrap_inquiry .box_search {
	width: 701px;
	padding: 13px 0 0 15px;
	border-top: 1px solid #fcfcfc;
	border-left: 1px solid #fcfcfc;
}

#deliveryColl .wrap_inquiry .info_delivery {
	float: left;
}

#deliveryColl .wrap_inquiry .info_delivery .tit {
	float: left;
	padding-right: 4px;
	font-size: 12px;
	font-weight: bold;
	line-height: 22px;
	color: #000;
	clear: both;
}

#deliveryColl .wrap_inquiry .info_delivery .cont {
	float: left;
	width: 154px;
}

#deliveryColl .wrap_inquiry .inp_txt {
	float: left;
	width: 140px;
	margin-right: 5px;
}

#deliveryColl .wrap_inquiry .btn_inquiry {
	display: block;
	overflow: hidden;
	float: left;
	width: 41px;
	height: 23px;
	padding: 0;
	border: 0;
	background:
		url(http://i1.daumcdn.net/imgsrc.search/search_all/2011/btn/btn_delivery.gif)
		no-repeat 0 0;
	font-size: 0;
	line-height: 0;
	text-indent: -999em;
	cursor: pointer;
}

#deliveryColl .wrap_inquiry .delivery_num .cont {
	width: 190px;
}

#deliveryColl .wrap_inquiry .refer {
	float: left;
	margin: 6px 0 0 6px;
	font: normal 11px '돋움', dotum;
	color: #777;
	line-height: 13px;
} /* 관련정보 */
#deliveryColl .list_relation {
	margin: 12px 0 0 0;
	clear: both;
}
</style>
        <script type="text/javascript">
									var changeDeleveryComp = function() {
										var selectedVal = $('_jsDeliveryCorpListHiddenSelBox').options[$('_jsDeliveryCorpListHiddenSelBox').selectedIndex].value;
										if ($('kocn_number').value == ""
												|| $('kocn_number').value == "예)1234567890"
												|| $('kocn_number').value == "11자리 숫자만 입력"
												|| $('kocn_number').value == "예)PKR000249650") {
											if (selectedVal == 4) {
												$('kocn_number').value = "11자리 숫자만 입력";
											} else if (selectedVal == 7) {
												$('kocn_number').value = "예)PKR000249650";
											} else {
												$('kocn_number').value = "예)1234567890";
											}
										}
										if (selectedVal == 4) {
											$('deleveryInfoMes').innerHTML = "Master Air Waybill만 조회 가능합니다.";
										} else if (selectedVal == 7) {
											$('deleveryInfoMes').innerHTML = "예)PKR000249650 (12자리)";
										} else {
											$('deleveryInfoMes').innerHTML = "예:1234567890 (숫자만 입력하세요.)";
										}
									};
									var focusDeleveryNum = function() {
										if ($('kocn_number').value == "예)1234567890"
												|| $('kocn_number').value == "11자리 숫자만 입력"
												|| $('kocn_number').value == "예)PKR000249650") {
											$('kocn_number').value = "";
										}
									};
									var blurDeleveryNum = function() {
										if ($('kocn_number').value == "") {
											if ($('_jsDeliveryCorpListHiddenSelBox').options[$('_jsDeliveryCorpListHiddenSelBox').selectedIndex].value == 4) {
												$('kocn_number').value = "11자리 숫자만 입력";
											} else if ($('_jsDeliveryCorpListHiddenSelBox').options[$('_jsDeliveryCorpListHiddenSelBox').selectedIndex].value == 7) {
												$('kocn_number').value = "예)PKR000249650";
											} else {
												$('kocn_number').value = "예)1234567890";
											}
										}
									};
								</script>
        <div id="deliveryColl" class="wid_w">
            <div class="coll_tit">
                <h2 class="tit">택배 및 항공화물 조회</h2>
            </div>
            <div class="coll_cont">
                <div class="mg_cont">
                    <div class="wrap_inquiry">
                        <div class="box_search">
                            <form name="kocn_mm" method="post" target="_blank" onsubmit="return kocnSubmit();">
                                <fieldset>
                                    <legend>택배 및 항공화물 조회</legend>
                                    <input type="hidden" name="InvNo"> <input type="hidden" name="f_slipno"> <input type="hidden" name="sheetno"> <input type="hidden"
                                                name="sendno"> <input type="hidden" name="billno1"> <input type="hidden" name="billno2"> <input type="hidden" name="billno3">
                                                                <input type="hidden" name="tc"> <input type="hidden" name="cust_id"> <input type="hidden" name="invc_no"> <input
                                                                            type="hidden" name="slipnom"> <input type="hidden" name="gubun"> <input type="hidden" name="slipno">
                                                                                        <input type="hidden" name="slipno_salecd"> <input type="hidden" name="iv_no"> <input
                                                                                                type="hidden" name="search_item_no"> <input type="hidden" name="mode" value="SEARCH"> <input
                                                                                                        type="hidden" name="search_type" value="1"> <input type="hidden" name="searchMethod"
                                                                                                            value="I"> <input type="hidden" name="bl_num"> <input type="hidden"
                                                                                                                    name="dtdShtno"> <input type="hidden" name="sid1"> <input
                                                                                                                            type="hidden" name="wbl_num"> <input type="hidden" name="hawb_no">
                                                                                                                                    <dl class="info_delivery">
                                                                                                                                        <dt class="tit">업체명</dt>
                                                                                                                                        <dd class="cont">
                                                                                                                                            <select id="_jsDeliveryCorpListHiddenSelBox"
                                                                                                                                                name="_jsDeliveryCorpListHiddenSelBox"
                                                                                                                                                class="select_box" onchange="changeDeleveryComp();">
                                                                                                                                                <option value="0">선택해 주세요</option>
                                                                                                                                                <option value="1">경동택배</option>
                                                                                                                                                <option value="2">대신택배</option>
                                                                                                                                                <option value="3" selected>대한통운택배</option>
                                                                                                                                                <option value="4">대한항공</option>
                                                                                                                                                <option value="5">동부택배</option>
                                                                                                                                                <option value="6">로젠택배</option>
                                                                                                                                                <option value="7">범한판토스</option>
                                                                                                                                                <option value="8">우체국택배</option>
                                                                                                                                                <option value="9">일양로지스택배</option>
                                                                                                                                                <option value="10">한덱스택배</option>
                                                                                                                                                <option value="11">한의사랑택배</option>
                                                                                                                                                <option value="12">한진택배</option>
                                                                                                                                                <option value="13">현대택배</option>
                                                                                                                                                <option value="14">CJGLS택배</option>
                                                                                                                                                <option value="15">CVSnet편의점택배</option>
                                                                                                                                                <option value="16">DHL택배</option>
                                                                                                                                                <option value="17">FedEx택배</option>
                                                                                                                                                <option value="18">GTX택배</option>
                                                                                                                                                <option value="19">KG옐로우캡택배</option>
                                                                                                                                                <option value="20">KGB택배</option>
                                                                                                                                                <option value="21">OCS택배</option>
                                                                                                                                                <option value="22">TNT Express</option>
                                                                                                                                                <option value="23">UPS택배</option>
                                                                                                                                            </select>
                                                                                                                                        </dd>
                                                                                                                                    </dl>
                                                                                                                                    <dl class="info_delivery delivery_num">
                                                                                                                                        <dt class="tit">송장번호</dt>
                                                                                                                                        <dd class="cont">
                                                                                                                                            <input id="kocn_number" type="text" class="inp_txt"
                                                                                                                                                style="width: 130px" name="kocn_number"
                                                                                                                                                value="12893712213" onfocus='focusDeleveryNum();'
                                                                                                                                                onblur='blurDeleveryNum();'> <input
                                                                                                                                                type="submit" class="btn_bus btn_inquiry" value="조회">
                                                                                                                                        </dd>
                                                                                                                                    </dl>
                                                                                                                                    <div class="refer" id="deleveryInfoMes">예:1234567890 (숫자만
                                                                                                                                        입력하세요.)</div>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script type="text/javascript">
									var _jsDeliveryCompanyArr = [
											[ "0", "선택해주세요" ],
											[
													"1",
													"경동택배",
													{
														cpName : "경동",
														url : "http://www.kdexp.com/sub4_1.asp?stype=1&p_item=##NUM##"
													} ],
											[
													"2",
													"대신택배",
													{
														cpName : "대신",
														url : "http://home.daesinlogistics.co.kr/daesin/jsp/d_freight_chase/d_general_process2.jsp"
													} ],
											[
													"3",
													"대한통운택배",
													{
														cpName : "대한통운",
														url : "https://www.doortodoor.co.kr/parcel/doortodoor.do?fsp_action=PARC_ACT_002&fsp_cmd=retrieveInvNoACT&invc_no=##NUM##"
													} ],
											[
													"4",
													"대한항공",
													{
														cpName : "대한항공",
														url : "http://cargo.koreanair.com/ecus/trc/servlet/TrackingServlet?pid=5&version=kor&menu1=m1&menu2=m01-1&awb_no=##NUM##"
													} ],
											[
													"5",
													"동부택배",
													{
														cpName : "동부익스프레스",
														url : "http://www.dongbups.com/newHtml/delivery/dvsearch_View.jsp?item_no=##NUM##"
													} ],
											[
													"6",
													"로젠택배",
													{
														cpName : "로젠",
														url : "http://www.ilogen.com/iLOGEN.Web.New/TRACE/TraceView.aspx"
													} ],
											[
													"7",
													"범한판토스",
													{
														cpName : "범한판토스",
														url : "http://www.epantos.com/jsp/gx/tracking/tracking/trackingInquery.jsp?refNo=##NUM##"
													} ],
											[
													"8",
													"우체국택배",
													{
														cpName : "우체국",
														url : "http://service.epost.go.kr/trace.RetrieveRegiPrclDeliv.postal"
													} ],
											[
													"9",
													"일양로지스택배",
													{
														cpName : "일양로지스",
														url : "http://www.ilyanglogis.com/functionality/tracking_result.asp"
													} ],
											[
													"10",
													"한덱스택배",
													{
														cpName : "한덱스",
														url : "http://btob.sedex.co.kr/work/app/tm/tmtr01/tmtr01_s4.jsp?IC_INV_NO=##NUM##"
													} ],
											[
													"11",
													"한의사랑택배",
													{
														cpName : "한의사랑",
														url : "http://www.hanips.com/html/sub03_03_1.html?logicnum=##NUM##"
													} ],
											[
													"12",
													"한진택배",
													{
														cpName : "한진",
														url : "http://www.hanjin.co.kr/Delivery_html/inquiry/result_waybill.jsp?wbl_num=##NUM##"
													} ],
											[
													"13",
													"현대택배",
													{
														cpName : "현대",
														url : "http://www.hlc.co.kr/personalService/tracking/06/tracking_goods_result.jsp?InvNo=##NUM##"
													} ],
											[
													"14",
													"CJGLS택배",
													{
														cpName : "CJGLS",
														url : "http://nexs.cjgls.com/web/service02_01.jsp?slipno=##NUM##"
													} ],
											[
													"15",
													"CVSnet편의점택배",
													{
														cpName : "CVSNET편의점",
														url : "http://was.cvsnet.co.kr/_ver2/board/ctod_status.jsp?invoice_no=##NUM##"
													} ],
											[
													"16",
													"DHL택배",
													{
														cpName : "DHL",
														url : "http://www.dhl.co.kr/content/kr/ko/express/tracking.shtml?brand=DHL&AWB=##NUM##"
													} ],
											[
													"17",
													"FedEx택배",
													{
														cpName : "FEDEX",
														url : "http://www.fedex.com/Tracking?ascend_header=1&clienttype=dotcomreg&cntry_code=kr&language=korean&tracknumbers=##NUM##"
													} ],
											[
													"18",
													"GTX택배",
													{
														cpName : "GTX",
														url : "http://www.gtx2010.co.kr/del_inquiry_result.html?s_gbn=1&awblno=##NUM##"
													} ],
											[
													"19",
													"KG옐로우캡택배",
													{
														cpName : "KG옐로우캡",
														url : "http://www.yellowcap.co.kr/custom/inquiry_result.asp?INVOICE_NO=##NUM##"
													} ],
											[
													"20",
													"KGB택배",
													{
														cpName : "KGB",
														url : "http://www.kgbls.co.kr/sub5/trace.asp?f_slipno=##NUM##"
													} ],
											[
													"21",
													"OCS택배",
													{
														cpName : "OCS",
														url : "http://www.ocskorea.com/online_bl_multi.asp?mode=search&search_no=##NUM##"
													} ],
											[
													"22",
													"TNT Express",
													{
														cpName : "TNTExpress",
														url : "http://www.tnt.com/webtracker/tracking.do?respCountry=kr&respLang=ko&searchType=CON&cons=##NUM##"
													} ],
											[
													"23",
													"UPS택배",
													{
														cpName : "UPS",
														url : "http://www.ups.com/WebTracking/track?loc=ko_KR&InquiryNumber1=##NUM##"
													} ] ];
									if (totCollCount == "1") {
										daum.$("mCenter").style.paddingBottom = "100px";
									}
									function kocnSubmit() {
										var num = daum.$("kocn_number").value;
										var kocn_1 = daum
												.$("_jsDeliveryCorpListHiddenSelBox").value;
										var selected_text = daum
												.$("_jsDeliveryCorpListHiddenSelBox")[kocn_1].innerHTML;
										if (num == "") {
											alert('송장번호를 입력해주세요');
											return false;
										}
										if (kocn_1 == ""
												|| !_jsDeliveryCompanyArr[kocn_1]
												|| kocn_1 == "0"
												|| selected_text == "선택해주세요") {
											alert('업체명을 선택하세요');
											return false;
										}
										num = num.replaceAll('-', '');
										var url = _jsDeliveryCompanyArr[kocn_1][2].url;
										smartLog(
												null,
												"s=TO&a=ABQK&d=&pg=1&r=1&p=1&rc=1&u="
														+ encodeURIComponent(url),
												"");
										if (url.match(/##NUM##/)) {
											window.open(url.replace(/##NUM##/,
													num), "kocnss");
											return false;
										} else {
											switch (kocn_1) {
											case "2":
												document.kocn_mm.method = "GET";
												document.kocn_mm.billno1.value = num
														.substring(0, 4);
												document.kocn_mm.billno2.value = num
														.substring(4, 7);
												document.kocn_mm.billno3.value = num
														.substring(7, 13);
												break;
											case "6":
												document.kocn_mm.method = "GET";
												document.kocn_mm.slipno.value = num;
												document.kocn_mm.gubun.value = "slipno";
												break;
											case "8":
												document.kocn_mm.sid1.value = num;
												break;
											case "10":
												document.kocn_mm.method = "GET";
												document.kocn_mm.hawb_no.value = num;
												break;
											case "15":
												document.kocn_mm.method = "GET";
												document.kocn_mm.slipno.value = num;
												break;
											}
										}
										document.kocn_mm.action = url;
									}
									(function() {
										changeDeleveryComp();
									})();
								</script>
        <!-- end 택배조회Coll -->
























    </form>
</body>
</html>