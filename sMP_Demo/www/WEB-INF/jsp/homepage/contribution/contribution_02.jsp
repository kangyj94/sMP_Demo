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
function MM_showHideLayers() { //v9.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) 
  with (document) if (getElementById && ((obj=getElementById(args[i]))!=null)) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v=='hide')?'hidden':v; }
    obj.visibility=v; }
}
</script>
<style type="text/css">
#apDiv0 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	top:0 auto;
}
#apDiv1 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
#apDiv2 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
#apDiv3 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
#apDiv4 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
#apDiv5 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
#apDiv6 {
	position:absolute;
	width:200px;
	height:115px;
	z-index:1;
	visibility: hidden;
	top:0 auto;
}
</style>
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
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_07.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_07.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contribution_st_02.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 사회공헌 &gt;<span class="orange"> 활동분야 </span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contribution_txt_box.gif" alt="SK텔레시스는 정기적인 시설 봉사 등의 사회공헌 활동 이외에도 시즌행사, 그룹행사, 기부활동을 통해 사회적 나눔을 실천하고 있습니다." width="757" height="69" /></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contribution_02_st_01.gif" alt="SK텔레시스의 나눔실천 현장" width="200" height="21" /></td>
              </tr>
              <tr>
                <td colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left">
                <!-- 현장사진 시작-->
                <table width="720" border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td width="400" valign="top">
                    <!-- 큰사진 영역 시작-->
                    <div id="apDiv0">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13.jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">김치만들기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv1">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13.jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">김치만들기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv2">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(37).jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">김치만들기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv3">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(33).jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">빵 나누기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv4">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(29).jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">빵 나누기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv5">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(25).jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">송편빗기</td>
                      </tr>
                    </table>
                    </div>
                    <div id="apDiv6">
                    <table width="300" border="0" cellspacing="0" cellpadding="1">
                      <tr>
                        <td><table width="300" border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC">
                          <tr>
                            <td bgcolor="#FFFFFF"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(21).jpg" width="355" height="214" /></td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="30" align="center">송편빗기</td>
                      </tr>
                    </table>
                    </div>
                    <!-- 큰사진 영역 끝-->
                    </td>
                    <td valign="top">
                    <!-- 작은사진 영역 시작-->
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(0).jpg" width="83" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','show','apDiv2','','hide','apDiv3','','hide','apDiv4','','hide','apDiv5','','hide','apDiv6','','hide')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">김치만들기</td>
                          </tr>
                        </table></td>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(38).jpg" width="82" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','hide','apDiv2','','show','apDiv3','','hide','apDiv4','','hide','apDiv5','','hide','apDiv6','','hide')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">김치만들기</td>
                          </tr>
                        </table></td>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(34).jpg" width="82" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','hide','apDiv2','','hide','apDiv3','','show','apDiv4','','hide','apDiv5','','hide','apDiv6','','hide')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">빵 나누기</td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="5" align="center"></td>
                        <td height="5" align="center"></td>
                        <td height="5" align="center"></td>
                      </tr>
                      <tr>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(30).jpg" width="82" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','hide','apDiv2','','hide','apDiv3','','hide','apDiv4','','show','apDiv5','','hide','apDiv6','','hide')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">빵 나누기</td>
                          </tr>
                        </table></td>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(26).jpg" width="82" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','hide','apDiv2','','hide','apDiv3','','hide','apDiv4','','hide','apDiv5','','show','apDiv6','','hide')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">송편빗기</td>
                          </tr>
                        </table></td>
                        <td align="center"><table width="80" border="0" cellspacing="0" cellpadding="1">
                          <tr>
                            <td><table width="80" border="0" cellspacing="1" cellpadding="3" bgcolor="#CCCCCC">
                              <tr>
                                <td bgcolor="#FFFFFF"><a href="#"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/upload/2012-12-13(22).jpg" width="82" height="58" border="0" onclick="MM_showHideLayers('apDiv0','','hide','apDiv1','','hide','apDiv2','','hide','apDiv3','','hide','apDiv4','','hide','apDiv5','','hide','apDiv6','','show')" /></a></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="30" align="center">송편빗기</td>
                          </tr>
                        </table></td>
                      </tr>
                      <tr>
                        <td height="5" align="center"></td>
                        <td height="5" align="center"></td>
                        <td height="5" align="center"></td>
                      </tr>
                      <tr>
                        <td height="20" colspan="3" align="center"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_first.gif" width="17" height="11" border="0" /><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_prev.gif" width="14" height="11" hspace="5" border="0" /> <span class="orange bold">1</span> <a href="contribution_02_02.jsp">2</a> <a href="contribution_02_02.jsp"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_next.gif" width="14" height="11" hspace="5" border="0" /></a><a href="contribution_02_02.jsp"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_last.gif" width="17" height="11" border="0" /></a></td>
                        </tr>
                    </table>
                    <!-- 작은사진 영역 끝-->
                    </td>
                  </tr>
                </table>
                <!-- 현장사진 끝-->
                </td>
              </tr>
              <tr>
                <td height="50" colspan="2" align="left">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contribution_img_03.gif" alt="사회공헌활동 (CSR:Corporate Socail Responsibility) 분야
                	교육/장학
                	- 임직원 심폐소생술 교육
                	환경
                	- 나무심기
                	- 국립서울현충원 정화
                	- 근로 지역 환경 정화
                	사회복지
                	- 김장행상
                	- 시각장애인용 전자도서입력
                	- 해비타트 사랑의 집짓기
                	- 장애아동들과 나들이 (봄,가을 소풍 등)
                  - 자폐아동들 생활 보조
                  - 헌형
                  - 연탄배달
                  기부
                  - 국내외 사고 및 재난 복구 지원
                  - (인도네시아 차당지진, 중국 쓰촨성 지진, 이천 화재, 일본 대지진 등)
                  기타
                  - SK그룹 행복바자회
                  - 프로보노 (재능기부활동)" width="717" height="374" /></td>
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