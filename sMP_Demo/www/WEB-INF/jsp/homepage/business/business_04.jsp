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
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_02.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_02.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_st_04.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 사업소개 &gt;<span class="orange"> 상품별 보증납기</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_04_st_01.gif" alt="RF/Cable류" width="200" height="20" /></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="subTitle01">납품 소요일</td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="7" class="table_top_line"></td>
                  </tr>
                  <tr>
                    <td width="150" rowspan="3" class="bbs_td_subject2">철가류의                       종류</td>
                    <td class="table_td_split2"></td>
                    <td width="180" rowspan="3" class="bbs_td_subject2">주문시간</td>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="bbs_td_subject2">SK Telesys                       거래조건</td>
                    </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    <td width="250" class="bbs_td_subject2">평상시</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">긴급시</td>
                  </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="150" rowspan="9"><font color="#663333">RF류 <br />
전선류<br />
부자재</font></td>
                    <td class="table_td_split2"></td>
                    <td>평일 00:00 ~ 19:00</td>
                    <td class="table_td_split2"></td>
                    <td width="250"><font color="#990000">D+1일 18:00이전                       (도서지역 D+2일)</font></td>
                    <td class="table_td_split2"></td>
                    <td rowspan="9">요구시간 이내</td>
                    </tr>
                  <tr>
                    <td></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>평일 19:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td rowspan="3"><font color="#990000">D+2일 18:00이전                       (도서지역 D+3일)</font></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 00:00 ~ 14:00</td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 14:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+3일 18:00이전                       (도서지역 D+4일)</font></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>일요일 00:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+2일 18:00이전                       (도서지역 D+3일)</font></td>
                    <td class="table_td_split2"></td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_bottom_line"></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="notice_txt01">도착시간 별도 지정시 “긴급시”로 간주 </td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="notice_ex"><font color="#990000">당일 발주후 익일 12:00시까지 배송요청 등</font></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="subTitle01">납품 보증일</td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="5" class="table_top_line"></td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                  </tr>
                  <tr>
                    <td width="150" class="bbs_td_subject2">자재의 종류</td>
                    <td class="table_td_split2"></td>
                    <td width="180" class="bbs_td_subject2">납품 보증일</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">보증일 경과에 따른 벌칙</td>
                    </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td><font color="#663333">RF류<br />
전선류<br />
부자재</font></td>
                    <td class="table_td_split2"></td>
                    <td>D+3일</td>
                    <td class="table_td_split2"></td>
                    <td>납품보증일 경과시 지체상금 지급 (하루당 주문대금의 0.015%)</td>
                    </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_bottom_line"></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_04_st_02.gif" alt="철가/철탑류" width="200" height="20" /></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="subTitle01">납품 소요일</td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="7" class="table_top_line"></td>
                  </tr>
                  <tr>
                    <td width="150" rowspan="3" class="bbs_td_subject2">철가류의                       종류</td>
                    <td class="table_td_split2"></td>
                    <td width="180" rowspan="3" class="bbs_td_subject2">주문시간</td>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="bbs_td_subject2">SK Telesys                       거래조건</td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                    <td width="250" class="bbs_td_subject2">평상시</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">긴급시</td>
                  </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="150" rowspan="9"><font color="#663333">월폴,                       간이폴,<br />
                      간이트러스트,<br />
                      삼각,사각철탑</font></td>
                    <td class="table_td_split2"></td>
                    <td>평일 00:00 ~ 19:00</td>
                    <td class="table_td_split2"></td>
                    <td width="250"><font color="#990000">D+4일 18:00이전                       (도서지역 D+5일)</font></td>
                    <td class="table_td_split2"></td>
                    <td rowspan="9">협의된 요구시간 이내</td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>평일 19:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td rowspan="3"><font color="#990000">D+5일 18:00이전                       (도서지역 D+6일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 00:00 ~ 14:00</td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 14:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+6일 18:00이전                       (도서지역 D+7일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>일요일 00:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+5일 18:00이전                       (도서지역 D+6일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="150" rowspan="9"><font color="#663333">전주,                       IP주</font></td>
                    <td class="table_td_split2"></td>
                    <td>평일 00:00 ~ 19:00</td>
                    <td class="table_td_split2"></td>
                    <td width="250"><font color="#990000">D+3일 18:00이전                       (도서지역 D+4일)</font></td>
                    <td class="table_td_split2"></td>
                    <td rowspan="9">협의된 요구시간 이내</td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>평일 19:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td rowspan="3"><font color="#990000">D+4일 18:00이전                       (도서지역 D+5일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 00:00 ~ 14:00</td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 14:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+5일 18:00이전                       (도서지역 D+6일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>일요일 00:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+4일 18:00이전                       (도서지역 D+5일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="150" rowspan="9"><font color="#663333">강관주,<br />
                      철주, 철탑</font></td>
                    <td class="table_td_split2"></td>
                    <td>평일 00:00 ~ 19:00</td>
                    <td class="table_td_split2"></td>
                    <td width="250"><font color="#990000">D+7일 18:00이전                       (도서지역 D+8일)</font></td>
                    <td class="table_td_split2"></td>
                    <td rowspan="9">협의된 요구시간 이내</td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>평일 19:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td rowspan="3"><font color="#990000">D+8일 18:00이전                       (도서지역 D+9일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 00:00 ~ 14:00</td>
                    <td class="table_td_split2"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>토요일 14:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+9일 18:00이전                       (도서지역 D+10일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td class="table_td_split2"></td>
                    <td colspan="3" class="table_middle_line"></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td class="table_td_split2"></td>
                    <td>일요일 00:00 ~ 24:00</td>
                    <td class="table_td_split2"></td>
                    <td><font color="#990000">D+8일 18:00이전                       (도서지역 D+9일)</font></td>
                    <td class="table_td_split2"></td>
                  </tr>
                  <tr>
                    <td colspan="7" class="table_bottom_line"></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="notice_txt01">도착시간 별도 지정시 “긴급시”로 간주 </td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="notice_ex"><font color="#990000"> 당일 발주후 익일 12:00시까지 배송요청 등</font></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left" class="subTitle01">납품 보증일</td>
              </tr>
              <tr>
                <td colspan="2" class="space5"></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="5" class="table_top_line"></td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                  </tr>
                  <tr>
                    <td width="150" class="bbs_td_subject2">자재의 종류</td>
                    <td class="table_td_split2"></td>
                    <td width="180" class="bbs_td_subject2">납품 보증일</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">보증일 경과에 따른 벌칙</td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                    </tr>
                  <tr class="bbs_td_contents2">
                    <td><font color="#663333">월폴, 간이폴, <br />
                      간이트러스트, <br />
                      옥상형 삼각,<br />
                      사각 철탑</font></td>
                    <td class="table_td_split2"></td>
                    <td>D+4일</td>
                    <td class="table_td_split2"></td>
                    <td>납품보증일 경과시 지체상금 지급 (하루당 주문대금의 0.015%)</td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td><font color="#663333">전주, IP주</font></td>
                    <td class="table_td_split2"></td>
                    <td>D+3일</td>
                    <td class="table_td_split2"></td>
                    <td>납품보증일 경과시 지체상금 지급 (하루당 주문대금의 0.015%)</td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td><font color="#663333">강관주,<br />
                      철주, 철탑</font></td>
                    <td class="table_td_split2"></td>
                    <td>D+10일</td>
                    <td class="table_td_split2"></td>
                    <td>납품보증일 경과시 지체상금 지급 (하루당 주문대금의 0.015%)</td>
                  </tr>
                  <tr>
                    <td colspan="5" class="table_bottom_line"></td>
                  </tr>
                </table>
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