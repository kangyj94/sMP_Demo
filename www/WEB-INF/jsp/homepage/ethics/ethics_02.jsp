<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>OK Plaza에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>
<script type="text/javascript">
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
</script>
</head>
<body>
<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" height="101px">
    <!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 --></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><!-- 메인 컨텐츠 시작-->
      <table width="977" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_04.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_04.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_st_02.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 윤리경영 &gt;<span class="orange"> 윤리규범</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left"><p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_box2.gif" alt="본 윤리실천지침은 윤리규범 중 "구성원"의 윤리를 올바르게 이해하고 실천할 수 있도록 구성원들에게 행동과 판단의 기준을 제공하는데 
그 목적이 있다." width="757" height="69" /><br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s11.gif" alt="1. 공정한 업무수행" width="300" height="38" /><br />
                    <br />
                    <strong>가. 금품</strong><br />
  <br />
                    구성원은 이해관계자 및 구성원 상호간에 금품을 제공하거나 받지 
                    않아야 한다.<br />
                    <br />
                    1) 금품이란 현금, 유가증권(상품권, 회원권 포함), 경조금, 물품
                    등을 말한다.<br />
                    2) 불가피하게 금품을 수수한 경우 즉시 반송 한 후 차상위자에게 
                    보고하고 윤리경영 담당부서에 신고한다.<br />
                    3) 반송이 곤란한 경우 윤리경영 담당부서에 금품을 전달하고, 윤리
                    경영 담당부서는 해당 금품을 사회봉사단체 등에 기증한다.<br />
                    4) 예외 인정의 경우<br />
  <br />
                    가) 물품<br />
  <br />
                    - 회사 로고나 명칭이 표시되어 있으며, 그 가격이 사회
                    통념상 인정되는 간소한 수준의 홍보 또는 행사 기념품을
                    제공하거나 받는 경우<br />
                    - 각종 계약 또는 제휴 업무 추진시 의례적으로 상호
                    교환하는 선물이나 기념품<br />
                    - 경영활동과 관련하여 선물을 제공할 필요가 있어, 
                  담당임원 이상의 직책자로부터 승인을 얻은 경우 </p>
                  <p>나) 경조금<br />
                    <br />
                    - 상부상조의 취지에 따라 사회통념상 인정되는 간소한
                    수준을 넘지 않는 금액</p>
                  <p>다) 화분<br />
                    <br />
                    - 승진, 영전, 취임 등과 관련되어 사회통념상 인정되는 
                    간소한 수준을 넘지 않는 화분이나 화환</p>
                  <p><strong>나. 접대•편의 </strong><br />
                    <br />
                    구성원은 이해관계자 및 구성원 상호간에 접대나 편의를 제공하거나
                    받지 않아야 한다.<br />
                    <br />
                    1)	접대란, 대가를 기대하여 이해관계자와의 식사, 음주, 스포츠, 
                    오락 등 발생한 비용을 일방에게 부담시키거나 부담하는 행위를
                    말하며,<br />
                    편의란, 금품, 접대를 제외한 숙박 및 교통편 제공, 관광안내, 
                    행사지원(협찬, 찬조) 등 상대방의 개인이나 단체 활동에 필요한<br />
                    수단을 제공하거나 받는 행위를 말한다. <br />
                    2) 부득이한 사정으로 접대나 편의를 주고 받은 경우 차상위자에게 
                    보고하고, 윤리경영 담당부서에 신고한다. <br />
                    3) 예외 인정의 경우 <br />
                    <br />
                    가) 식사<br />
                    - 업무협의나 처리를 위한 사회통념상 인정되는 간소한 
                    수준의 식사를 하는 경우<br />
                    나) 교육 편의<br />
                    - 이해관계자가 주최하는 교육과 관련하여 공식적으로 
                    숙식 및 교통 편의를 제공 받을 경우<br />
                    다) 협찬•찬조<br />
                    - 단체 행사시 사회통념상 인정되는 간소한 수준으로 
                    제공하거나 받을 경우<br />
                    라) 기타<br />
                    - 경영활동과 관련하여 접대•편의를 제공할 필요가 있어,
                    담당임원 이상의 직책자로부터 승인을 얻은 경우 <br />
                    - 고객으로부터 접대•편의를 제공 받은 경우<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s12.gif" alt="2. 재산 및 정보 보호" width="300" height="38" /><br />
                    <br />
                    <strong>가.	 재산보호</strong><br />
  <br />
                    1)	제품 설계도 등의 무형자산 및 업무용 고정자산 등을 회사 
                    경영활동 외에 개인적인 목적을 위해 무단으로 전출, 전용하지 
                    않는다. <br />
                    2)	회사의 재산을 본인 또는 제3자에게 저가로 양도•대여하거나
                    본인 또는 제3자의 재산을 회사가 고가로 구입•차용하도록 하지 
                    않는다.<br />
                    3)	회사 공금의 무단 인출, 회계장부의 조작, 허위 청구서 제출
                    등을 통한 개인 착복, 제3자에 증여하는 행위 등을 하여서는
                    안된다.<br />
                    4) 회사 재산에 중대한 손실을 가져올 상황이 발생하거나 가능성이
                    있을 경우 즉시 회사에 보고하고 손실을 최소화 할 수 있는 
                    조치를 취한다.</p>
                  <p><strong>나. 정보보호</strong><br />
                    <br />
                    1) 고객정보는 불법으로 제3자에게 제공하지 않는다.<br />
                    2) 공개되지 않아야 하는 영업비밀 또는 회사내부 정보(회사거래처
                    정보 포함)를 사전 승인 없이 내•외부에 제공하지 않는다.<br />
                    3) 회사에 유용한 정보라 할지라도 부당한 방법으로 취득하거나 
                    활용하지 않는다.<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s13.gif" alt="3. 윤리실천지침 준수" width="300" height="38" /></p>
                  <p><strong>가. 지침 준수의 의무</strong><br />
                    <br />
                    구성원은 본 윤리실천지침을 준수하여야 하며, 본인이 본 지침을
                    위반한 경우 자기신고를 해야 한다.<br />
                    다른 구성원이 본 지침을 위반한 사실을 명백히 인지한 경우에는
                    윤리경영 담당부서에 구체적인 내용으로 제보하여야 하며, <br />
                    음해 등 다른 목적으로 제보하여서는 안된다.<br />
  <br />
                    <strong>나. 검토과정에서의 명예 보존</strong><br />
  <br />
                    본 지침의 위반 유무를 검토하는 동안에 자기신고를 한 구성원이나 
                    제보를 당한 구성원의 명예가 손상되지 않도록 비밀을 유지하여야 
                    한다.</p>
                  <p> <strong>다. 지침 위반 내용 처리</strong><br />
                    <br />
                    1)	위반 사항이 경미할 경우에는 관련 구성원 및 이해관계자에게 
                    윤리경영의 취지를 설명하고 재발방지를 요구한다. <br />
                    또한, 수수한 금품 및 접대•편의에 해당하는 경제적 가치의
                    반환을 요구할 수 있다.<br />
                    2) 추가 심의가 필요한 중대한 사안일 경우 윤리경영 담당부서는 
                    인사위원회에 상정할 수 있다. </p>
                  <p><strong>라. 제보자 보호 및 포상</strong><br />
                    <br />
                    1) 제보자 보호 <br />
                    제보자의 신분 및 제보 내용은 보호해야 하며, 제보행위로 인한
                    불이익을 주지 않는다. <br />
                    2) 제보자 포상<br />
                    제보로 인하여 회사의 이익에 크게 기여한 경우나 위험 요인을
                    크게 감소시킨 제보자는 포상 할 수 있다.<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s14.gif" alt="4. 용어의 정의" width="300" height="38" /><br />
                    <br />
                    <strong>가.	사회통념상 인정되는 간소한 수준</strong><br />
  <br />
                    건전한 상식을 가진 대부분의 사람이 수용할 수 있어야 하며, 
                    업무를 공정히 처리하는데 지장을 주지 않는 수준을 말한다.<br />
                    건전한 상식이라 함은 다음과 같은 조건을 충족하여야 한다.<br />
  <br />
                    1) 우월적 지위에 의한 강압이나 요구에 의한 것이 아니어야 함<br />
                    2) 수수•제공행위에 대해 스스로 거부감을 가지지 않아야 함<br />
                    3) 사회적인 미풍양속에 저촉되지 않아야 함<br />
                    4) 빈번하거나 습관적이지 않아야 함<br />
                    5) 업무 진행상 중요한 시기, 목적과 연계되지 않아야 함<br />
                    6) 개인의 급여소득에 비추어 부담이 되지 않는 수준이어야 함<br />
  <br />
                    <strong>나. 이해관계자</strong><br />
  <br />
                    업무 수행으로 인하여 권리 또는 이익에 직접적인 영향을 받을 
                    수 있는 개인, 고객, 협력사 등을 의미한다. <br />
                    <br />
                    <strong>다. 구성원</strong><br />
  <br />
                    SK텔레시스의 임원 및 정규직, 비정규직을 포함한 모든 직원을 
                    말한다.<br />
                    <br />
                    <strong>라. 윤리경영 담당부서</strong><br />
  <br />
                    윤리경영을 실천하기 위한 제도를 구축하고 운영을 관할하며,
                지속적인 교육 프로그램을 개발/실시하는 부서를 말한다.</p></td>
              </tr>
            </table>
            <!-- 메인 컨텐츠 내용 끝-->
            </td>
        </tr>
      </table>
      <!-- 메인 컨텐츠 끝--></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
  </tr>
</table>
</body>
</html>