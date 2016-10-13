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
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_st_01.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 윤리경영 &gt;<span class="orange"> 윤리경영 소개</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left"><p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_box.gif" alt="SK텔레시스 구성원은 SKMS에 의거하여 일을 수행함에 있어, 윤리적인 판단과 행동의 기준이 될 수 있는 윤리규범을 제정하고 준수함으로써 고객/주주/구성원/협력업체/사회의 가치를 극대화하고 '투명한 경영' 
'신뢰 받는 일류기업'으로 도약 하고자 한다." width="757" height="69" /></p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s01.gif" alt="1장 고객" width="300" height="38" /><br />
                    <br />
                    고객을 지속적으로 만족시켜 고객으로부터 신뢰를 얻어야 하며 궁극적으로 고객과 더불어 
                  발전하여야 한다. </p>
                  <p>① 고객만족을 경영활동의 최우선 기준으로 삼는다. <br />
                    ② 진실한 마음과 친절한 태도로 고객의 의견을 존중하며, 고객과의
                    약속은 성실히 지킨다. <br />
                    ③ 고객이 알아야 하거나 고객에게 마땅히 알려야 하는 사실은 
                    정직하게 고객에게 알린다. <br />
                    ④ 고객과 관련된 정보는 고객 사전 동의 없이 그 정보를 외부에 
                    누설하거나 다른 용도로 사용하지 않는다.<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s02.gif" alt="2장 주주" width="300" height="38" /><br />
                    <br />
                    주주의 가치가 창출될 수 있도록 기업의 가치를 높여야 하며, 
                    이를 위해 투명성을 제고하고 효율적인 경영을 하여야 한다. </p>
                  <p> ① 효율적인 경영을 통해 기업가치를 제고하며, 주주의 요구∙제안∙결의
                    등을 존중한다. <br />
                    ② 경영자료는 제반법규 및 회계기준에 의거하여 작성한다.<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s03.gif" alt="3장 구성원" width="300" height="38" /><br />
                    <br />
                    구성원이 자발적•의욕적으로 일할 수 있도록 환경을 조성하고, 
                    모든 구성원은 SK 텔레시스의 발전을 위해 기여하여야 한다.<br />
                    <br />
                    ①  SK 텔레시스 구성원은 개개인의 존엄성과 가치를 존중한다.<br />
                    ② 구성원은 자부심과 긍지를 가지고 자신의 위치에서 항상
                    회사를 대표하는 자세로 스스로 명예와 품위를 지킨다.<br />
                    ③ 구성원은 본인에게 주어진 권한과 책임을 명확히 인식하고, 
                    회사가 추구하는 목표 달성을 위해 최선을 다한다.<br />
                    ④  Leader는 일반 구성원이 자발적•의욕적으로 일할 수 있도록 
                    환경을 조성하고, 공정하고 합리적인 인사관리를 한다. <br />
                    ⑤ 공정한 업무수행을 위하여 공과 사를 구분하며 회사와 
                    개인의 이해가 상충되지 않도록 한다.<br />
                    ⑥ 회사의 재산 및 정보를 보호한다.<br />
                  </p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s04.gif" alt="4장 Business Partner" width="300" height="38" /><br />
                    <br />
                    협력사와 공정하고 투명한 거래를 통하여 상호 Win Win 할 수 있도록 한다</p>
                  <p> ① 품질,원가 및 납기에 대한 고객의 기대를 만족시키기 위해 최대한
                    협력사의 지지를 얻도록 한다.<br />
                    ② 상호 거래 시 우월적 지위를 이용해 강요하는 행위나 일방적인 
                    판단으로 거래를 중단하는 등의 어떠한 형태의 부당행위도 
                    하지 않는다.<br />
                    ③ 협력회사가 경쟁력을 갖추어 성장할 수 있도록 지원하고 이를 
                    통해 창출되는 수익을 상호 공유한다.</p>
                  <p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/ethics_txt_s05.gif" alt="5장 국가와 사회" width="300" height="38" /><br />
                    <br />
                    경제발전에의 기여와 함께 사회적∙문화적 활동을 통하여 사회에 
                    공헌하며, 사회규범과 윤리기준에 맞는 경영을 하도록 최선을 
                    다한다.</p>
                  <p> ① 사업을 영위하는 지역의 제반 법규를 준수하고 현지
                    문화를 존중한다.<br />
                    ② 장학,복지사업 등 사회공헌활동을 통해 지역사회 발전에 기여한다.<br />
                </p></td>
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