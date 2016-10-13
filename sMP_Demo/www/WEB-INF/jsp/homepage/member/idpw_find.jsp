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
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_06.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_06.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/membership_st_01.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt;<span class="orange"> 아이디/비밀번호 찾기</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="center">
                <!-- 로그인영역 시작-->
                <table width="588" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/idpw_find_img_01.gif" width="588" height="121" /></td>
                    </tr>
                  <tr>
                    <td width="208"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_img_02.gif" width="208" height="140" /></td>
                    <td width="352">
                    <!-- 로그인폼 시작-->
                    <table width="352" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="idpwFind">SK 브로드밴드 담당자 : 김철 과장 010-9349-5500</td>
                        </tr>
                      <tr>
                        <td class="idpwFind">문의 전화 : 02) 2129-2049</td>
                        </tr>
                	</table>
                    <p>&nbsp;</p>
                    <p>
                      <!-- 로그인폼 시작-->
                      <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_img_05.gif" width="352" height="21" /></p></td>
                    <td width="28"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_img_03.gif" width="28" height="140" /></td>
                  </tr>
                  <tr>
                    <td colspan="3"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/login_img_04.gif" width="588" height="10" /></td>
                    </tr>
                </table>
                <!-- 로그인영역 끝-->
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