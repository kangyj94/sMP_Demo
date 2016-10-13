<%@page import="kr.co.bitcube.common.dto.LoginUserDto"%>
<%@page import="kr.co.bitcube.common.dto.WorkInfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils" %>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto" %>
<%@ page import="java.util.List"%>

<%
	String _menuId = request.getParameter("_menuId")==null ? "" : (String)request.getParameter("_menuId");
	if("".equals(_menuId)) _menuId = request.getAttribute("_menuId")==null ? "" : (String)request.getAttribute("_menuId");

	//그리드의 width와 Height을 정의
	String listHeight = "$(window).height()-248 + Number(gridHeightResizePlus)";
// 	String listWidth = "$(window).width()-50 + Number(gridWidthResizePlus)";
	String listWidth = "1500";

	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
	LoginUserDto userInfoDto = (LoginUserDto)(request.getSession()).getAttribute(Constances.SESSION_NAME);
   
	int EndYear   = 2008;
	int StartYear = Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[0]);
	int yearCnt = StartYear - EndYear + 1;
	String[] srcYearArr = new String[yearCnt];
	for(int i = 0 ; i < yearCnt ; i++){
	   srcYearArr[i] = (StartYear - i) + "";
	}       
	
	//메인페이지 경영정보 에서 보낸파라미터
	String transferStatus = CommonUtils.getString(request.getParameter("flag1"));//이관여부
	String isLimit = CommonUtils.getString(request.getParameter("flag2"));//주문제한여부
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp" %>
<style type="">
.page_table_contents {border-left:solid 1px #ccc; border-right:solid 1px #ccc; border-bottom:solid 1px #ccc; color:#000; padding-left:15px; padding-right:15px; height:22px; padding-top:4px; white-space:nowrap;}
</style>

<script type="text/javascript">
$(document).ready(function() {
	fnInit();
	
	$("#srcButton").click(function(){
		fnInit();	
	});
	
	$("#bondsButton").click(function(){
		fnDynamicForm("/adjust/adjustBondsTotal.sys", "_menuCd=ADM_ADJU_BOND","");		
	});
	
	$("#planButton").click(function(){
		fnDynamicForm("/adjust/adjustBondsPlan.sys", "_menuCd=ADM_ADJU_PLAN","");
	});
});

function fnInit(){
	fnMonthBondsList();
	fnBondsTypeList();
	fnBondsLateList();
	fnBondsReturnList();
	
	var toDayString = '<%=CommonUtils.getCurrentDate().substring(0, 7) %>';
	var searchDayString = $("#stdYear").val()+"-"+$("#stdMonth").val();
	if(toDayString==searchDayString) {
		$("#receiveRate").html('만기일 <%=CommonUtils.getCustomDay("DAY", -30) %> 부터 <%=CommonUtils.getCustomDay("DAY", 0) %> 까지 정상채권 회수 현황');
	} else {
		$("#receiveRate").html($("#stdYear").val()+'-'+$("#stdMonth").val()+'-01 부터 말일까지 정상채권 회수 현황');
	}
	$("#yearReceiveRate").html($("#stdYear").val()+' 년 회수율');
}

function fnComma(n, m) {
	
	var ex = Math.pow(10, m);
	
	n = Math.round(n);
	
	n = (n * ex) / ex;
// 	n = Math.round(n * ex)/ex;
	
	n += '';
	var reg = /(^[+-]?\d+)(\d{3})/;
	while (reg.test(n)){
	n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function fnMonthBondsList(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/getMonthBondsList.sys", 
		{
			"stdYear":$.trim($("#stdYear").val()),
			"stdMonth":$.trim($("#stdMonth").val())
		}, function(arg){ 
			var result = eval('(' + arg + ')').list;
			
			var m_1  = result[0].M1_AMOU  + result[1].M1_AMOU  - result[2].M1_AMOU;
			var m_2  = result[0].M2_AMOU  + result[1].M2_AMOU  - result[2].M2_AMOU;
			var m_3  = result[0].M3_AMOU  + result[1].M3_AMOU  - result[2].M3_AMOU;
			var m_4  = result[0].M4_AMOU  + result[1].M4_AMOU  - result[2].M4_AMOU;
			var m_5  = result[0].M5_AMOU  + result[1].M5_AMOU  - result[2].M5_AMOU;
			var m_6  = result[0].M6_AMOU  + result[1].M6_AMOU  - result[2].M6_AMOU;
			var m_7  = result[0].M7_AMOU  + result[1].M7_AMOU  - result[2].M7_AMOU;
			var m_8  = result[0].M8_AMOU  + result[1].M8_AMOU  - result[2].M8_AMOU;
			var m_9  = result[0].M9_AMOU  + result[1].M9_AMOU  - result[2].M9_AMOU;
			var m_10 = result[0].M10_AMOU + result[1].M10_AMOU - result[2].M10_AMOU;
			var m_11 = result[0].M11_AMOU + result[1].M11_AMOU - result[2].M11_AMOU;
			var m_12 = result[0].M12_AMOU + result[1].M12_AMOU - result[2].M12_AMOU;
			
			$("#3_m_1").html(fnComma(m_1/1000, 2));
			$("#3_m_2").html(fnComma(m_2/1000, 2));
			$("#3_m_3").html(fnComma(m_3/1000, 2));
			$("#3_m_4").html(fnComma(m_4/1000, 2));
			$("#3_m_5").html(fnComma(m_5/1000, 2));
			$("#3_m_6").html(fnComma(m_6/1000, 2));
			$("#3_m_7").html(fnComma(m_7/1000, 2));
			$("#3_m_8").html(fnComma(m_8/1000, 2));
			$("#3_m_9").html(fnComma(m_9/1000, 2));
			$("#3_m_10").html(fnComma(m_10/1000, 2));
			$("#3_m_11").html(fnComma(m_11/1000, 2));
			$("#3_m_12").html(fnComma(m_12/1000, 2));
			
			
			for(var i = 0 ; i < result.length ; i++){
				
				if(i == 2){
					$("#" + i + "_m_1").html( "<a href='javascript:fnBondsMonthDetail(\"01\");'><font color='blue'>"+fnComma(result[i].M1_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_2").html( "<a href='javascript:fnBondsMonthDetail(\"02\");'><font color='blue'>"+fnComma(result[i].M2_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_3").html( "<a href='javascript:fnBondsMonthDetail(\"03\");'><font color='blue'>"+fnComma(result[i].M3_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_4").html( "<a href='javascript:fnBondsMonthDetail(\"04\");'><font color='blue'>"+fnComma(result[i].M4_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_5").html( "<a href='javascript:fnBondsMonthDetail(\"05\");'><font color='blue'>"+fnComma(result[i].M5_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_6").html( "<a href='javascript:fnBondsMonthDetail(\"06\");'><font color='blue'>"+fnComma(result[i].M6_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_7").html( "<a href='javascript:fnBondsMonthDetail(\"07\");'><font color='blue'>"+fnComma(result[i].M7_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_8").html( "<a href='javascript:fnBondsMonthDetail(\"08\");'><font color='blue'>"+fnComma(result[i].M8_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_9").html( "<a href='javascript:fnBondsMonthDetail(\"09\");'><font color='blue'>"+fnComma(result[i].M9_AMOU/1000, 2) +"</font></a>");
					$("#" + i + "_m_10").html("<a href='javascript:fnBondsMonthDetail(\"10\");'><font color='blue'>"+fnComma(result[i].M10_AMOU/1000, 2)+"</font></a>");
					$("#" + i + "_m_11").html("<a href='javascript:fnBondsMonthDetail(\"11\");'><font color='blue'>"+fnComma(result[i].M11_AMOU/1000, 2)+"</font></a>");
					$("#" + i + "_m_12").html("<a href='javascript:fnBondsMonthDetail(\"12\");'><font color='blue'>"+fnComma(result[i].M12_AMOU/1000, 2)+"</font></a>");					
				}else{
					$("#" + i + "_m_1").html( fnComma(result[i].M1_AMOU/1000, 2));
					$("#" + i + "_m_2").html( fnComma(result[i].M2_AMOU/1000, 2));
					$("#" + i + "_m_3").html( fnComma(result[i].M3_AMOU/1000, 2));
					$("#" + i + "_m_4").html( fnComma(result[i].M4_AMOU/1000, 2));
					$("#" + i + "_m_5").html( fnComma(result[i].M5_AMOU/1000, 2));
					$("#" + i + "_m_6").html( fnComma(result[i].M6_AMOU/1000, 2));
					$("#" + i + "_m_7").html( fnComma(result[i].M7_AMOU/1000, 2));
					$("#" + i + "_m_8").html( fnComma(result[i].M8_AMOU/1000, 2));
					$("#" + i + "_m_9").html( fnComma(result[i].M9_AMOU/1000, 2));
					$("#" + i + "_m_10").html(fnComma(result[i].M10_AMOU/1000, 2));
					$("#" + i + "_m_11").html(fnComma(result[i].M11_AMOU/1000, 2));
					$("#" + i + "_m_12").html(fnComma(result[i].M12_AMOU/1000, 2));					
				}
			}
		}
	);
}

function fnBondsTypeList(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/getBondsTypeList.sys", 
		{
			"stdYear":$.trim($("#stdYear").val()),
			"stdMonth":$.trim($("#stdMonth").val())
		}, function(arg){ 
			var result = eval('(' + arg + ')').list;
			
			var stdYear = $.trim($("#stdYear").val());
			
			for(var i = 0 ; i < result.length ; i++){
				$("#" + result[i].BONDS_KIND + "_skt1").html("<a href='javascript:fnBondsDetail(\""+result[i].BONDS_KIND+"\",\""+10+"\");'><font color='blue'>"+fnComma(Math.round(result[i].SKT1/1000), 2) +"</font></a>");
				$("#" + result[i].BONDS_KIND + "_skb1").html("<a href='javascript:fnBondsDetail(\""+result[i].BONDS_KIND+"\",\""+20+"\");'><font color='blue'>"+fnComma(Math.round(result[i].SKB1/1000), 2) +"</font></a>");
				$("#" + result[i].BONDS_KIND + "_skb2").html("<a href='javascript:fnBondsDetail(\""+result[i].BONDS_KIND+"\",\""+50+"\");'><font color='blue'>"+fnComma(Math.round(result[i].SKB2/1000), 2) +"</font></a>");
				$("#" + result[i].BONDS_KIND + "_skb3").html("<a href='javascript:fnBondsDetail(\""+result[i].BONDS_KIND+"\",\""+30+"\");'><font color='blue'>"+fnComma(Math.round(result[i].SKB3/1000), 2) +"</font></a>");
				$("#" + result[i].BONDS_KIND + "_etc" ).html("<a href='javascript:fnBondsDetail(\""+result[i].BONDS_KIND+"\",\""+40+"\");'><font color='blue'>"+fnComma(Math.round(result[i].ETC /1000), 2) +"</font></a>");
			}
			
			var bonds0Tot = Math.round((result[0].SKT1 + result[0].SKB1 + result[0].SKB2 + result[0].SKB3 + result[0].ETC)/1000);
			var bonds1Tot = Math.round((result[1].SKT1 + result[1].SKB1 + result[1].SKB2 + result[1].SKB3 + result[1].ETC)/1000);
			var bonds2Tot = Math.round((result[2].SKT1 + result[2].SKB1 + result[2].SKB2 + result[2].SKB3 + result[2].ETC)/1000);
			var bonds3Tot = Math.round((result[3].SKT1 + result[3].SKB1 + result[3].SKB2 + result[3].SKB3 + result[3].ETC)/1000);
			
			$("#0_tot").html(fnComma(bonds0Tot,2));
			$("#1_tot").html(fnComma(bonds1Tot,2));
			$("#2_tot").html(fnComma(bonds2Tot,2));
			$("#3_tot").html(fnComma(bonds3Tot,2));
			
			var skt1Tot = Math.round((result[0].SKT1 + result[1].SKT1 + result[2].SKT1)/1000);
			var skb1Tot = Math.round((result[0].SKB1 + result[1].SKB1 + result[2].SKB1)/1000);
			var skb2Tot = Math.round((result[0].SKB2 + result[1].SKB2 + result[2].SKB2)/1000);
			var skb3Tot = Math.round((result[0].SKB3 + result[1].SKB3 + result[2].SKB3)/1000);
			var etcTot  = Math.round((result[0].ETC  + result[1].ETC  + result[2].ETC )/1000);
			var totAmou = skt1Tot+skb1Tot+skb2Tot+skb3Tot+etcTot; 	
			
			var rate0 = totAmou == 0 ? "0" : ((bonds0Tot/totAmou)*100).toFixed(1);
			var rate1 = totAmou == 0 ? "0" : ((bonds1Tot/totAmou)*100).toFixed(1);
			var rate2 = totAmou == 0 ? "0" : ((bonds2Tot/totAmou)*100).toFixed(1);
			
			$("#0_rate").html(rate0+" %");
			$("#1_rate").html(rate1+" %");
			$("#2_rate").html(rate2+" %");
			
			$("#tot_amou").html(fnComma(totAmou, 2));
			$("#tot_skt1").html(fnComma(skt1Tot, 0));
			$("#tot_skb1").html(fnComma(skb1Tot, 0));
			$("#tot_skb2").html(fnComma(skb2Tot, 0));
			$("#tot_skb3").html(fnComma(skb3Tot, 0));
			$("#tot_etc" ).html(fnComma(etcTot , 0));
		}
	);
}

function fnBondsLateList(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/getBondsLateList.sys", 
		{
			"stdYear":$.trim($("#stdYear").val()),
			"stdMonth":$.trim($("#stdMonth").val())
		}, function(arg){ 
			var result = eval('(' + arg + ')').list;

			var lateSum = Math.round((result[0].D30 + result[0].D60 + result[0].D90 + result[0].D120 + result[0].D150 + result[0].D180 + result[0].D181)/1000);
			
			$("#lateTot" ).html(fnComma(lateSum,2));
			$("#late_30" ).html(fnComma(Math.round(result[0].D30 /1000),2));
			$("#late_60" ).html(fnComma(Math.round(result[0].D60 /1000),2));
			$("#late_90" ).html(fnComma(Math.round(result[0].D90 /1000),2));
			$("#late_120").html(fnComma(Math.round(result[0].D120/1000),2));
			$("#late_150").html(fnComma(Math.round(result[0].D150/1000),2));
			$("#late_180").html(fnComma(Math.round(result[0].D180/1000),2));
			$("#late_181").html(fnComma(Math.round(result[0].D181/1000),2));
			
			var rate30  = lateSum == 0 ? "0" : (Math.round(result[0].D30 /1000)/lateSum*100).toFixed(1);
			var rate60  = lateSum == 0 ? "0" : (Math.round(result[0].D60 /1000)/lateSum*100).toFixed(1);
			var rate90  = lateSum == 0 ? "0" : (Math.round(result[0].D90 /1000)/lateSum*100).toFixed(1);
			var rate120 = lateSum == 0 ? "0" : (Math.round(result[0].D120/1000)/lateSum*100).toFixed(1);
			var rate150 = lateSum == 0 ? "0" : (Math.round(result[0].D150/1000)/lateSum*100).toFixed(1);
			var rate180 = lateSum == 0 ? "0" : (Math.round(result[0].D180/1000)/lateSum*100).toFixed(1);
			var rate181 = lateSum == 0 ? "0" : (Math.round(result[0].D181/1000)/lateSum*100).toFixed(1);
			
			$("#late_30_rate" ).html(rate30 + " %");
			$("#late_60_rate" ).html(rate60 + " %");
			$("#late_90_rate" ).html(rate90 + " %");
			$("#late_120_rate").html(rate120 + " %");
			$("#late_150_rate").html(rate150 + " %");
			$("#late_180_rate").html(rate180 + " %");
			$("#late_181_rate").html(rate181 + " %");			
			

		}
	);
}

function fnBondsReturnList(){
	$.post(
		"<%=Constances.SYSTEM_CONTEXT_PATH %>/adjust/getBondsReturnList.sys", 
		{
			"stdYear":$.trim($("#stdYear").val()),
			"stdMonth":$.trim($("#stdMonth").val())
		}, function(arg){ 
			var result1 = eval('(' + arg + ')').list1;
			var result2 = eval('(' + arg + ')').list2;
			
			$("#p_m_0").html(fnComma(result1[0].M0,2));
			$("#p_m_1").html(fnComma(result1[0].M1,2));
			$("#p_m_2").html(fnComma(result1[0].M2,2));
			$("#p_m_3").html(fnComma(result1[0].M0 + result1[0].M1 + result1[0].M2,2));
			$("#p_y_0").html(fnComma(result1[0].Y0,2));
			$("#p_y_1").html(fnComma(result1[0].Y1,2));
			$("#p_y_2").html(fnComma(result1[0].Y2,2));
			$("#p_y_3").html(fnComma(result1[0].Y0 + result1[0].Y1 + result1[0].Y2,2));
			
			$("#p_s_0").html(fnComma(result2[0].SALE_TOTA_AMOU,2));
			$("#p_s_1").html(fnComma(result2[0].PAY_AMOU,2));
			$("#p_s_2").html((result2[0].RTN_RATE).toFixed(1) + " %");
			$("#p_s_3").html((result2[0].ALL_TRN_RATE).toFixed(1) + " %");
			
			$("#r_m_0").html(fnComma(result1[1].M0,2)); 
			$("#r_m_1").html(fnComma(result1[1].M1,2)); 
			$("#r_m_2").html(fnComma(result1[1].M2,2)); 
			$("#r_m_3").html(fnComma(result1[1].M0 + result1[1].M1 + result1[1].M2,2)); 
			$("#r_y_0").html(fnComma(result1[1].Y0,2)); 
			$("#r_y_1").html(fnComma(result1[1].Y1,2)); 
			$("#r_y_2").html(fnComma(result1[1].Y2,2)); 
			$("#r_y_3").html(fnComma(result1[1].Y0 + result1[1].Y1 + result1[1].Y2,2)); 
			
			var m0_rate = result1[1].M0 == 0 || result1[0].M0 == 0 ? 0 : result1[1].M0 / result1[0].M0 * 100.00; 
			var m1_rate = result1[1].M1 == 0 || result1[0].M1 == 0 ? 0 : result1[1].M1 / result1[0].M1 * 100.00; 
			var m2_rate = result1[1].M2 == 0 || result1[0].M2 == 0 ? 0 : result1[1].M2 / result1[0].M2 * 100.00;
			
			var y0_rate = result1[1].Y0 == 0 || result1[0].Y0 == 0 ? 0 : result1[1].Y0 / result1[0].Y0 * 100.00; 
			var y1_rate = result1[1].Y1 == 0 || result1[0].Y1 == 0 ? 0 : result1[1].Y1 / result1[0].Y1 * 100.00; 
			var y2_rate = result1[1].Y2 == 0 || result1[0].Y2 == 0 ? 0 : result1[1].Y2 / result1[0].Y2 * 100.00;
			     
			$("#s_m_0").html(m0_rate.toFixed(1) + " %");
			$("#s_m_1").html(m1_rate.toFixed(1) + " %");
			$("#s_m_2").html(m2_rate.toFixed(1) + " %");
			$("#s_m_3").html((m0_rate + m1_rate + m2_rate).toFixed(1) + " %");
			$("#s_y_0").html(y0_rate.toFixed(1) + " %");
			$("#s_y_1").html(y1_rate.toFixed(1) + " %");
			$("#s_y_2").html(y2_rate.toFixed(1) + " %");
			$("#s_y_3").html((y0_rate + y1_rate + y2_rate).toFixed(1) + " %");
		}
	);
}
</script>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBondsTypeDetail(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/adjust/adjustBondsTypeDetailDiv.jsp"%>
<script>
function fnBondsDetail(bondsType, contType){
	var stdYear = $.trim($("#stdYear").val());
	var stdMonth = $.trim($("#stdMonth").val());
	fnBondsTypeDetail(stdYear, stdMonth, bondsType, contType);
}
</script>

<%
/**------------------------------------공급사팝업 사용방법---------------------------------
* fnBondsTypeDetail(vendorNm, callbackString) 을 호출하여 Div팝업을 Display ===
* borgNm : 찾고자하는 공급사명
* callbackString : 콜백함수(문자열), 콜백함수파라메타는 3개(vendor일련번호, 공급사명String, 권역코드) 
*/
%>
<%@ include file="/WEB-INF/jsp/adjust/adjustBondsMonthDetailDiv.jsp"%>
<script>
function fnBondsMonthDetail(stdMonth){
	var stdYear = $.trim($("#stdYear").val());
	fnBondsMonthDetailDiv(stdYear, stdMonth);
}
</script>

</head>

<jsp:include page="/WEB-INF/jsp/system/treeFrame/adminMenu.jsp" flush="false" />

<body style="background-color:#FFFFFF">
<table width="1500px" style="margin-bottom: 10px;" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<!-- 타이틀 시작 -->
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr valign="top">
					<td width="20" valign="middle">
						<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
					</td>
					<td height="29" class="ptitle">채권현황</td>
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
					<td colspan="8" class="table_top_line"></td>
				</tr>
				<tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
				</tr>
				<tr>
					<td class="table_td_subject" width="100">기준년월</td>
					<td class="table_td_contents">
						<select id="stdYear" name="stdYear" class="select" style="width: 70px;">
<%
   for(int i = 0 ; i < srcYearArr.length ; i++){
%>
							<option value='<%=srcYearArr[i]%>' <%=CommonUtils.getCustomDay("MONTH", 0).split("-")[0].equals(srcYearArr[i]) ? "selected" : "" %>><%=srcYearArr[i] %></option>
<%      
   }
%>                        
						</select> 년
                        <select id="stdMonth" name="stdMonth" class="select" style="width: 60px;">
<%
   for(int i = 0 ; i < 12 ; i++){
	   String monthVal = new Integer(i + 1).toString().length() == 1 ? "0" + new Integer(i + 1) : new Integer(i + 1).toString();
%>
							<option value='<%=monthVal%>' <%=Integer.parseInt(CommonUtils.getCustomDay("MONTH", 0).split("-")[1]) == i+1 ? "selected" : "" %>><%=monthVal %></option>
<%      
   }
%>                        
						</select> 월		                        
					</td>
					<td  align="right">
						금액단위 : 천원 &nbsp;&nbsp;
<%-- 						<a id='srcButton' class="btn btn-default btn-sm" style="<%=CommonUtils.getDisplayRoleButton(roleList, "COMM_READ")%>"><i class="fa fa-search"></i> 조회</a> --%>
						<a id='srcButton' class="btn btn-default btn-sm"><i class="fa fa-search"></i> 조회</a>
					</td>
				</tr>
                <tr>
					<td colspan="8" height="1" bgcolor="eaeaea"></td>
                </tr>
                <tr>
					<td colspan="8" class="table_top_line"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="20" valign="top">
                    	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                   	</td>
                   	<td class="stitle">월별채권 현황</td>
                   	<td style="text-align: right">
						<a id='bondsButton' class="btn btn-primary btn-xs"><i class="fa fa-search"></i> 채권관리 이동</a>                   		
                   	</td>                   	
               	</tr>
           	</table>
		</td>
	</tr>
	
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td class="table_td_subject" style="text-align: center;">구분</td>
                	<td class="table_td_subject" style="text-align: center;">1월</td>
                	<td class="table_td_subject" style="text-align: center;">2월</td>
                	<td class="table_td_subject" style="text-align: center;">3월</td>
                	<td class="table_td_subject" style="text-align: center;">4월</td>
                	<td class="table_td_subject" style="text-align: center;">5월</td>
                	<td class="table_td_subject" style="text-align: center;">6월</td>
                	<td class="table_td_subject" style="text-align: center;">7월</td>
                	<td class="table_td_subject" style="text-align: center;">8월</td>
                	<td class="table_td_subject" style="text-align: center;">9월</td>
                	<td class="table_td_subject" style="text-align: center;">10월</td>
                	<td class="table_td_subject" style="text-align: center;">11월</td>
                	<td class="table_td_subject" style="text-align: center;">12월</td>
               	</tr>
               	<tr>
               		<td class="page_table_contents">당월 초 채권 (A)</td>
               		<td id="0_m_1"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_2"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_3"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_4"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_5"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_6"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_7"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_8"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_9"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_10" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_11" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="0_m_12" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
               	<tr>
               		<td class="page_table_contents">당월 신규 채권 (B)</td>
               		<td id="1_m_1"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_2"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_3"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_4"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_5"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_6"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_7"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_8"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_9"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_10" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_11" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="1_m_12" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
               	<tr>
               		<td class="page_table_contents">당월 회수 채권 (C)</td>
               		<td id="2_m_1"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_2"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_3"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_4"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_5"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_6"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_7"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_8"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_9"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_10" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_11" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="2_m_12" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
               	<tr>
               		<td class="page_table_contents">채권 잔액 (A+B-C)</td>
               		<td id="3_m_1"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_2"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_3"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_4"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_5"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_6"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_7"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_8"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_9"  class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_10" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_11" class="page_table_contents" style="text-align: right;">0</td>
               		<td id="3_m_12" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
           	</table>
		</td>
	</tr>
	
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="20" valign="top">
                    	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                   	</td>
                   	<td class="stitle">채권유형별 현황</td>
                   	<td align="right">
                   	</td>                        	
               	</tr>
           	</table>
		</td>
	</tr>
	
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td class="table_td_subject" rowspan="2" style="text-align: center">구분</td>
                	<td class="table_td_subject" colspan="2" style="text-align: center">총계</td>
                	<td class="table_td_subject" colspan="5" style="text-align: center">고객유형별 현황</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject" style="text-align: center">금액</td>
                	<td class="table_td_subject" style="text-align: center">비중(%)</td>
                	<td class="table_td_subject" style="text-align: center">SKT 공사업체</td>
                	<td class="table_td_subject" style="text-align: center">SKB 공사업체</td>
                	<td class="table_td_subject" style="text-align: center">SKB 수주지입</td>
                	<td class="table_td_subject" style="text-align: center">SKB 행복센터</td>
                	<td class="table_td_subject" style="text-align: center">일반</td>
               	</tr>

            	<tr>
                	<td class="table_td_subject">정상채권</td>
                	<td id="0_tot"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_skt1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_skb1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_skb2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_skb3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="0_etc"  class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">관리채권</td>
                	<td id="1_tot"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_skt1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_skb1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_skb2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_skb3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="1_etc"  class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">장기채권</td>
                	<td id="2_tot"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_skt1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_skb1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_skb2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_skb3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="2_etc"  class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">총계</td>
                	<td id="tot_amou" class="table_td_subject" style="text-align: right;">0</td>
                	<td id="tot_rate" class="table_td_subject" style="text-align: right;"></td>
                	<td id="tot_skt1" class="table_td_subject" style="text-align: right;">0</td>
                	<td id="tot_skb1" class="table_td_subject" style="text-align: right;">0</td>
                	<td id="tot_skb2" class="table_td_subject" style="text-align: right;">0</td>
                	<td id="tot_skb3" class="table_td_subject" style="text-align: right;">0</td>
                	<td id="tot_etc"  class="table_td_subject" style="text-align: right;">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">이관채권</td>
                	<td id="3_tot"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="3_rate" class="page_table_contents" style="text-align: right;"></td>
                	<td id="3_skt1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="3_skb1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="3_skb2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="3_skb3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="3_etc"  class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
           	</table>
		</td>
	</tr>

	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="20" valign="top">
                    	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                   	</td>
                   	<td class="stitle">채권지연일별 현황</td>
                   	<td align="right">
                   	</td>
               	</tr>
           	</table>
		</td>
	</tr>
	
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td class="table_td_subject" rowspan="2" style="text-align: center">미회수 채권</td>
                	<td class="table_td_subject" colspan="7" style="text-align: center">채권 잔액 현황</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject" style="text-align: center">30일 이내</td>
                	<td class="table_td_subject" style="text-align: center">60일 이내</td>
                	<td class="table_td_subject" style="text-align: center">90일 이내</td>
                	<td class="table_td_subject" style="text-align: center">120일 이내</td>
                	<td class="table_td_subject" style="text-align: center">150일 이내</td>
                	<td class="table_td_subject" style="text-align: center">180일 이내</td>
                	<td class="table_td_subject" style="text-align: center">181일 경과</td>
               	</tr>
            	<tr>
                	<td id="lateTot"  class="page_table_contents" style="text-align: right;" rowspan="2">000</td>
                	<td id="late_30"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_60"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_90"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_120" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_150" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_180" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_181" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
            	<tr>    
                	<td id="late_30_rate"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_60_rate"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_90_rate"  class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_120_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_150_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_180_rate" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="late_181_rate" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
           	</table>
		</td>
	</tr>
	
	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td width="20" valign="top">
                    	<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" width="5" height="5" class="bullet_stitle" />
                   	</td>
                   	<td class="stitle">채권회수 현황</td>
                   	<td align="right">
						<a id='planButton' class="btn btn-primary btn-xs"><i class="fa fa-search"></i> 채권회수 계획수립</a>                   	
                   	</td>                        	
               	</tr>
           	</table>
		</td>
	</tr>

	<tr>
		<td width="100%" height="40px" valign="bottom">
			<table width="100%" style="height: 27px;border-top:solid 1px #ccc;" border="0" cellpadding="0" cellspacing="0">
            	<tr>
                	<td class="table_td_subject" rowspan="2" style="text-align: center">구분</td>
                	<td class="table_td_subject" colspan="4" style="text-align: center">당월 계획</td>
                	<td class="table_td_subject" colspan="4" style="text-align: center">년 누적 계획</td>
                	<td id="receiveRate" class="table_td_subject" colspan="3" style="text-align: center">부터의 정상채권 회수 현황</td>
                	<td id="yearReceiveRate" class="table_td_subject" rowspan="2" style="text-align: center">년 회수율</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject" style="text-align: center">정상</td>
                	<td class="table_td_subject" style="text-align: center">관리</td>
                	<td class="table_td_subject" style="text-align: center">장기</td>
                	<td class="table_td_subject" style="text-align: center">소계</td>
                	<td class="table_td_subject" style="text-align: center">정상</td>
                	<td class="table_td_subject" style="text-align: center">관리</td>
                	<td class="table_td_subject" style="text-align: center">장기</td>
                	<td class="table_td_subject" style="text-align: center">소계</td>
                	<td class="table_td_subject" style="text-align: center">만기대상금액</td>
                	<td class="table_td_subject" style="text-align: center">회수금액</td>
                	<td class="table_td_subject" style="text-align: center">회수율</td>
               	</tr>

            	<tr>
                	<td class="table_td_subject">계획금액</td>
                	<td id="p_m_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_m_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_m_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_m_3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_y_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_y_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_y_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_y_3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="p_s_0" class="page_table_contents" style="text-align: right;" rowspan="3">0</td>
                	<td id="p_s_1" class="page_table_contents" style="text-align: right;" rowspan="3">0</td>
                	<td id="p_s_2" class="page_table_contents" style="text-align: right;" rowspan="3">0</td>
                	<td id="p_s_3" class="page_table_contents" style="text-align: right;" rowspan="3">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">회수금액</td>
                	<td id="r_m_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_m_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_m_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_m_3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_y_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_y_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_y_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="r_y_3" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
            	<tr>
                	<td class="table_td_subject">회수율</td>
                	<td id="s_m_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_m_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_m_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_m_3" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_y_0" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_y_1" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_y_2" class="page_table_contents" style="text-align: right;">0</td>
                	<td id="s_y_3" class="page_table_contents" style="text-align: right;">0</td>
               	</tr>
           	</table>
		</td>
	</tr>
</table>
<br/>
<div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;"><p>처리할 데이터를 선택 하십시오!</p></div>
</body>
</html>