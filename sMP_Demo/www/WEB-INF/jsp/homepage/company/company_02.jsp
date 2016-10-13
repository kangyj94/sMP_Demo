<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_01.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_01.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/company_st_02.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 회사소개 &gt;<span class="orange"> 연혁</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left" valign="top"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_txt_box.gif" alt="항상 새로운 도약을 꿈꾸는 SK텔레시스는 오늘도 앞을 향해 달리고 있습니다." width="757" height="48" /></td>
              </tr>
              <tr>
                <td colspan="2" align="left" valign="top">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left">
                <!-- 연혁시작-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="100" valign="top" class="hisNum">2012</td>
                    <td width="657" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>05월</strong></td>
                        <td height="20">세계 최초 듀얼밴드(멀티캐리어) 브릿지 개발 성공 </td>
                        </tr>
                      <tr>
                        <td height="20"><strong>03월</strong></td>
                        <td height="20">세계 최초 펨토셀(소형 LTE기지국) 개발 성공 (06월 SK텔레콤 세계최초 펨토셀 상용화 성공)</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2011</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td height="20"><strong>09월</strong></td>
                        <td height="20">군통신장비 사업 진출 MOU 체결 (휴니드社)</td>
                        </tr>
                      <tr>
                        <td width="40" height="20"><strong>08월</strong></td>
                        <td height="20"> 2011 대구세계육상선수권대회용 AP개발 및 경기장 설치</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>05월</strong></td>
                        <td height="20"> 두번째 스마트폰 `WYNN(윈)' 출시</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2010</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>10월</strong></td>
                        <td height="20">`W'스마트폰 S100출시</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>07월</strong></td>
                        <td height="20">`W' 세번째 휴대폰 아우라폰 SK-900 출시</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>05월</strong></td>
                        <td height="20">`W' 두번째 휴대폰 비폰 SK-800 출시</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2009</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>11월</strong></td>
                        <td height="20"> `W' 휴대폰 출시</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>05월</strong></td>
                        <td height="20">중동 쿨라컴요르단社 와이맥스 상용 장비 수출</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>03월</strong></td>
                        <td height="20">SK텔레콤향 건물 내 음영지역 해소 전용 AP시스템 `IB Cell' 제주 상용화</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2008</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>11월</strong></td>
                        <td height="20">SK브래드밴드向 VoIP폰 공급 계약 체결</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>10월</strong></td>
                        <td height="20">와이브로 시스템 유럽시험인증기관 EOTC `CE마크' 획득</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>10월</strong></td>
                        <td height="20">SK텔레콤向 인빌딩 AP시스템 `IB Cell' 첫 시연</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>03월</strong></td>
                        <td height="20">인도네시아 경찰대학병원 의료정보시스템 구축사업</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2007</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>10월</strong></td>
                        <td height="20">인도네시아 경찰청 무선 원격감시시스템 구축 프로젝트 수주 (1,300만 달러 규모)</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>09월</strong></td>
                        <td height="20">군 전술 정보통신체계(TICN)수주 (삼성탈레스-SK텔레시스 컨소시엄)</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>07월</strong></td>
                        <td height="20">e-Navigating Project 해양수산부/해양대와 해양통신 공동 연구</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2006</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>08월</strong></td>
                        <td height="20">일본向 초소형 중계기 개발 및 日소프트뱅크社 수출</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>06월</strong></td>
                        <td height="20">세계 2번째 와이브로 웨이브1 상용화</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2005</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>11월</strong></td>
                        <td height="20">ISO 14001 인증 획득</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>03월</strong></td>
                        <td height="20">동기망 보급형 및 WCDMA 보급형 광 중계기 개발 및 양산체제 구축</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>01월</strong></td>
                        <td height="20">통합형 중계기(보급형) 양산체제 구축</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2004</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>07월</strong></td>
                        <td height="20">2G/3G 통합형 중계기 개발 착수, 저가형 광/RF 중계기 자체 개발</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2003</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>07월</strong></td>
                        <td height="20">Most Reliable Network Partner 비전 선포</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>04월</strong></td>
                        <td height="20">SK텔레시스(주)로 사명 변경</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2002</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>10월</strong></td>
                        <td height="20">Speed중계기 자체 개발 및 생산</td>
                        </tr>
                      <tr>
                        <td height="20"><strong>03월</strong></td>
                        <td height="20">SK텔레시스(주)로 사명 변경</td>
                        </tr>
                      
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">2001</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>01월</strong></td>
                        <td height="20">대주주 변동 SKC(주)</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">1998</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>10월</strong></td>
                        <td height="20"> (주)NSI Technology로 사명 변경</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                  <tr>
                    <td valign="top" class="hisNum">1997</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="40" height="20"><strong>03월</strong></td>
                        <td height="20">SMAT정보통신(주) 설립</td>
                        </tr>
                      </table></td>
                  </tr>
                  <tr>
                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/history_line.gif" width="757" height="16" /></td>
                  </tr>
                </table>
                <!-- 연혁끝-->
                </td>
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