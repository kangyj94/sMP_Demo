<%@page import="crosscert.Hash"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery-ui-1.8.2.custom.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.layout.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/i18n/grid.locale-kr.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.alphanumeric.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/Validation.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.ui.datepicker-ko.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.formatCurrency-1.4.0.pack.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.maskedinput-1.3.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jshashtable-2.1.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.blockUI.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/custom.common.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.money.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_JSCSS_URL %>/jq/js/jquery.number.js" type="text/javascript"></script>
<!--  
/*********************************** 공인인증서 모듈 관련 ***********************************
-->
<%
	Calendar cal = Calendar.getInstance();
	Date currentTime = cal.getTime();
	
	/* 서명시 서명원본을 구성하기 현재 시간을 구해옴.
	   구해진 현재시간에서 해쉬값을 추출함.
	*/
	SimpleDateFormat formatter=new SimpleDateFormat("yyyy-MM-dd-hh:mm:ss");
	String timestr=formatter.format(currentTime);
	
	int nRet;
	String Origin_data = ""; 
	Hash hash = new Hash();
	nRet = hash.GetHash(timestr.getBytes(), timestr.getBytes().length);
	
	if(nRet==0)		Origin_data = new String(hash.contentbuf);
	else			Origin_data = "abcdefghijklmnopqrstuvwxyz1234567890";	
%>
<!--  
/*********************************** 공인인증서 모듈 관련 ***********************************
-->

<!-- 초기세팅 및 선택값 리턴 스크립트 -->
<script type="text/javascript">
function init()
{
	var Ret;
	var policies = "";

	// 법인상호연동용(범용)                             		//
	policies +="1.2.410.200004.5.2.1.1"    + "|";          	// 한국정보인증               	법인
	policies +="1.2.410.200004.5.1.1.7"    + "|";          	// 한국증권전산               	법인, 단체, 개인사업자
	policies +="1.2.410.200005.1.1.5"      + "|";          	// 금융결제원                 	법인, 임의단체, 개인사업자
	policies +="1.2.410.200004.5.3.1.1"    + "|";          	// 한국전산원                 	기관(국가기관 및 비영리기관)
	policies +="1.2.410.200004.5.3.1.2"    + "|";          	// 한국전산원                 	법인(국가기관 및 비영리기관을  제외한 공공기관, 법인)
	policies +="1.2.410.200004.5.4.1.2"    + "|";          	// 한국전자인증               	법인, 단체, 개인사업자
	policies +="1.2.410.200004.5.4.1.201"    + "|";         // 한국전자인증               	전자인증 법인 인터텟뱅킹용
	policies +="1.2.410.200012.1.1.3"      + "|";          	// 한국무역정보통신           	법인  
	policies +="1.2.410.200004.5.4.2.26"      + "|";        // 한국전자인증           		특정용 세무조사법  
	
	// 법인 특정용 인증서(OID)
	policies +="1.2.410.200005.1.1.2"      + "|";          // 금융결제원                 법인 인터넷뱅킹용
	policies +="1.2.410.200005.1.1.6.8"      + "|";          // 금결원에서 발급한 국세청 세금계산서용 OID	
	
	try{
		Ret =  document.CC_Object_id.SetCommonInfoFromVal("211.192.169.70",4502, "211.192.169.180",389, "211.192.169.180",389, "CN=ROOT-RSA-CRL,OU=ROOTCA,O=KISA,C=KR", "no", policies);	
	}catch(e){
		alert(e);
		alert("공인인증서 모듈을 설치해야 진행하실수 있습니다.\nOKPLAZA 사이트를 다시 시작하여 공인인증서모듈을 \n설치해주세요.");
		return false;
	}
	
	if ( Ret != 0 ){ 
		alert( "인증 초기 설정에 실패하였습니다." );
		$("#businessNum").val("");
		return false;
	}else{
		Ret =  document.CC_Object_id.SetPKCSInform(1, 0, 0, 0, 0, 0, 0, 1, "SEED");
		if ( Ret != 0 ){ 
			alert( "인증 초기 설정에 실패하였습니다." );
			$("#businessNum").val("");
			return false;
		}else{
			return true;
		}
	}	
}

function fnAuthBusinessNumber(businessNum){
	if ($.trim(businessNum) == ""){
		alert("사업자등록번호를  입력하세요.");
		return false;
	}
		
	// 환경설정 함수 콜
	init();
	var ret;
	var signeddata;
	var userdn;
	
	// 인증서 선택창 초기화 및 선택된 인증서의 DN 추출
	// DN은 인증기관에서 유니크한 것임.
	try{
		userdn = document.CC_Object_id.GetUserDN();	
	}catch(e){
		return false;
	}
	
	if( userdn == null || userdn == "" ){ 
		alert(" 사용자 DN 선택이 취소 되었습니다.");
		//$("#businessNum").val("");
		return false;
	}else{
		/* 서명시 서명원본을 구성하기 현재 시간을 구해옴.
		   구해진 현재시간에서 해쉬값을 추출한 결과와 사용자 아이디를 더한 값을 서명함.
		*/
		var SignSrc = $.trim($("#src").val());//document.frm.src.value;
		signeddata = document.CC_Object_id.SignData( SignSrc, "SHA1", "");
		
		if( signeddata == null || signeddata == "" ){
			errmsg = document.CC_Object_id.GetErrorContent();
			errcode = document.CC_Object_id.GetErrorCode();
			alert( "SignData :"+errmsg );
			//$("#businessNum").val("");
			return false;
		}else{
			getR = CC_Object_id.GetRFromKey(userdn, "");
			
			if (getR == ""){
				alert("주민번호/사업자번호를 확인할 수 없는 인증서입니다.");
				//$("#businessNum").val("");
				return false;
			}
	
			ret = CC_Object_id.ValidCert_VID(userdn, getR, businessNum);
			if (ret != "0"){
				alert("본인확인에 실패했습니다. 선택한 인증서의 사업자번호와 일치하지 않습니다.\n\n해당 인증기관에 문의하시기 바랍니다.");
				$("#businessNum").val("");
				return false;
			}else{
				//alert("본인확인에 성공하였습니다.");
				$("#signed_data").val(signeddata);
				return true;
			}
		}
	}//DN 추출 If문 끝
}

</script>
</head>
<body>
	<input id="src" name="src" type="hidden" value="<%=Origin_data%>"/>
	<input id="signed_data" name="signed_data" type="hidden"/>
	<input id="userDn" name="userDn" type="hidden"/>
</body>
</html>
