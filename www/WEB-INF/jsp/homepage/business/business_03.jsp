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
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_st_03.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 사업소개 &gt;<span class="orange"> 상품소개</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="179"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_item_01.gif" alt="대분류[50개]" width="179" height="55" /></td>
                    <td width="15"></td>
                    <td width="177"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_item_02.gif" alt="중분류[50개]" width="177" height="55" /></td>
                    <td width="15"></td>
                    <td width="177"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_item_03.gif" alt="품명[400개]" width="177" height="55" /></td>
                    <td width="15">&nbsp;</td>
                    <td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/business_item_04.gif" alt="규격[2000개]" width="177" height="55" /></td>
                  </tr>
                  <tr>
                    <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 철가류</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> CABLE류</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> RF류</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 기타자재</td>
                      </tr>
                      <tr>
                        <td class="table_bottom_line"></td>
                      </tr>
                    </table></td>
                    <td></td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 자립식 철탑</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 급전선 랙</td>
                      </tr>
                      <tr>
                        <td class="table_bottom_line"></td>
                      </tr>
                    </table></td>
                    <td></td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 닥터 케이블랙 수평</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 급전선 랙 기둥</td>
                      </tr>
                      <tr>
                        <td class="table_bottom_line"></td>
                      </tr>
                    </table></td>
                    <td>&nbsp;</td>
                    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 200 X 150</td>
                      </tr>
                      <tr>
                        <td class="table_middle_line"></td>
                      </tr>
                      <tr>
                        <td class="table_td_contents"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_folder.gif" width="14" height="11" align="absmiddle"/> 300 X 150</td>
                      </tr>
                      <tr>
                        <td class="table_bottom_line"></td>
                      </tr>
                    </table></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td height="20" colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="7" class="table_top_line"></td>
                  </tr>
                  <tr>
                    <td colspan="3" class="bbs_td_subject2">철가류</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">Cable류</td>
                    <td class="table_td_split2"></td>
                    <td class="bbs_td_subject2">RF류</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="189">표준철가</td>
                    <td class="table_td_split2"></td>
                    <td width="189">개선형 삼각철탑</td>
                    <td class="table_td_split2"></td>
                    <td width="189">절연애자</td>
                    <td class="table_td_split2"></td>
                    <td>RF케이블</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>급전선인입구</td>
                    <td class="table_td_split2"></td>
                    <td>사각철탑</td>
                    <td class="table_td_split2"></td>
                    <td>동대</td>
                    <td class="table_td_split2"></td>
                    <td>Coupler</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>케이블랙</td>
                    <td class="table_td_split2"></td>
                    <td>삼각철탑작업대</td>
                    <td class="table_td_split2"></td>
                    <td>접지단자함</td>
                    <td class="table_td_split2"></td>
                    <td>디바이더</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>덕트</td>
                    <td class="table_td_split2"></td>
                    <td>삼각철탑</td>
                    <td class="table_td_split2"></td>
                    <td>접지봉</td>
                    <td class="table_td_split2"></td>
                    <td>검쇄기</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>급전선랙</td>
                    <td class="table_td_split2"></td>
                    <td>간이트러스</td>
                    <td class="table_td_split2"></td>
                    <td>전원선</td>
                    <td class="table_td_split2"></td>
                    <td>더미</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>축전지받침대</td>
                    <td class="table_td_split2"></td>
                    <td>간이플</td>
                    <td class="table_td_split2"></td>
                    <td>접지선</td>
                    <td class="table_td_split2"></td>
                    <td>광점퍼코드</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>자립식철탑</td>
                    <td class="table_td_split2"></td>
                    <td>원플</td>
                    <td class="table_td_split2"></td>
                    <td>전선관</td>
                    <td class="table_td_split2"></td>
                    <td>&nbsp;</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>자립식철주</td>
                    <td class="table_td_split2"></td>
                    <td>CONC'전주형</td>
                    <td class="table_td_split2"></td>
                    <td>압착단자</td>
                    <td class="table_td_split2"></td>
                    <td>&nbsp;</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>강관주</td>
                    <td class="table_td_split2"></td>
                    <td>장비받침대</td>
                    <td class="table_td_split2"></td>
                    <td>피뢰침 애자형</td>
                    <td class="table_td_split2"></td>
                    <td>&nbsp;</td>
                    </tr>
                  <tr>
                    <td colspan="7" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td>IP주</td>
                    <td class="table_td_split2"></td>
                    <td>기타</td>
                    <td class="table_td_split2"></td>
                    <td>기타</td>
                    <td class="table_td_split2"></td>
                    <td>&nbsp;</td>
                    </tr>
                  <tr>
                  <tr>
                    <td colspan="7" class="table_bottom_line"></td>
                  </tr>
              </table></td>
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